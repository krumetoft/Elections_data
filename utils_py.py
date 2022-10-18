from readline import set_completion_display_matches_hook
import pandas as pd
from itertools import chain

MAIN_PATH = "elections/elections2022/"
PARTIES_LINK = MAIN_PATH + "cik_parties_02.10.2022.txt"
SECTIONS_LINK = MAIN_PATH + "sections_02.10.2022.txt"
VOTES_LINK = MAIN_PATH + "votes_02.10.2022.txt"

def read_parties(link_to_file):
    return pd.read_csv(link_to_file, sep=';', names=['party_code', 'party_name'])

def add_party_alias(dataf):
    alias_dict = {
        "Движение за права и свободи – ДПС": "ДПС",
        "Продължаваме Промяната": "ПП",
        "ВЪЗРАЖДАНЕ": "ВЪЗРАЖДАНЕ",
        "БЪЛГАРСКИ ВЪЗХОД": "БЪЛГАРСКИ ВЪЗХОД",
        "ПП ИМА ТАКЪВ НАРОД": "ИТН",
        "ГЕРБ-СДС": "ГЕРБ",
        'ДЕМОКРАТИЧНА БЪЛГАРИЯ – ОБЕДИНЕНИЕ (ДА България, ДСБ, Зелено движение)': "ДБ",
        "БСП ЗА БЪЛГАРИЯ": "БСП"
    }
    return dataf.assign(
        party_alias = lambda d: d['party_name'].map(alias_dict)
    ).assign(
        party_alias = lambda d: d['party_alias'].fillna('други')
    )

def read_sections(link_to_file):
    """ 
1) Пълен код на секция(код на район(2), община(2), адм. район(2), секция(3))
  2) Идентификатор на административна единица, за която се гласува в секцията
  3) Име на административна единица, за която се гласува в секцията
  4) ЕКАТТЕ на населеното място
  5) Име на Населено място, където е регистрирана секцията (за секциите извън страната - Държава, Населено място)
  6) Адрес на секцията
  7) Флаг мобилна секция
  8) Флаг корабна секция
  9) Брой машини за гласуване в секцията
"""

    return pd.read_csv(link_to_file, sep=';(?=\S)', 
    names=['section_code', 'admin_entity_code','admin_entity_name', 'ekatte_code', 'location', 'address', 'mobile_flag', 'ship_flag', 'nr_machines'],
    engine = 'python'
    )


def read_votes(link_to_file):

    with open(link_to_file) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=';')
        results_list = []
        for row in csv_reader:
            n_form = row[0]
            section_code = row[1]
            admin_entity_code = row[2]

            parties_iter = iter(row[3:])
            parties_dict = dict(zip(parties_iter, parties_iter))

            section_results_list = [(n_form, section_code, admin_entity_code, k, v) for k,v in parties_dict.items()]
            results_list = [*results_list,*section_results_list]

    return pd.DataFrame(results_list, columns=['nr_form', 'section_code', 'admin_entity_code', 'party_code', 'votes']).astype({'votes': 'int32'})


read_parties(PARTIES_LINK).pipe(add_party_alias)
read_sections(SECTIONS_LINK).head()

votes_per_section = read_votes(VOTES_LINK)
X = votes_per_section.groupby(['section_code', 'party_code']).agg({'votes': 'sum'}).unstack('party_code').fillna(0)


def votes_section_wider(votes_df):
    return votes_df.groupby(['section_code', 'party_code']).agg({'votes': 'sum'}).unstack('party_code').fillna(0)


from sklearn.preprocessing import RobustScaler
from sklearn.pipeline import make_pipeline
from sklearn.ensemble import IsolationForest

clf = make_pipeline(RobustScaler(), IsolationForest(max_samples=100, random_state=2022))
clf.fit(X)

y_pred_train = clf.predict(X)

X.assign(outliers = y_pred_train).loc[lambda d: d['outliers'] == -1]


import umap
import matplotlib.pyplot as plt
reducer = umap.UMAP()
X_reduced = make_pipeline(RobustScaler(), reducer).fit_transform(X)


plt.scatter(
    X_reduced[:, 0],
    X_reduced[:, 1],
    c=y_pred_train,
    alpha=0.3
    )
plt.gca().set_aspect('equal', 'datalim')
plt.title('Outlier sections', fontsize=24);
plt.show()