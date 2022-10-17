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

    results_df = pd.DataFrame()

    with open(link_to_file) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=';')
        results_list = []
        for row in csv_reader:
            n_form = row[0]
            section_code = row[1]
            admin_entity_code = row[2]

            parties_iter = iter(row[3:])
            parties_dict = dict(zip(parties_iter, parties_iter))
            results_list.append([n_form, section_code, admin_entity_code, parties_dict])

            section_df = pd.DataFrame(parties_dict, index = [0]).T.reset_index()
            section_df.columns = ['party_code', 'votes']
            section_df = section_df.assign(
                n_form = n_form,
                section_code = section_code,
                admin_entity_code = admin_entity_code
            )

            results_df = pd.concat([results_df, section_df])

    return results_df

initial_fields = ['form_nr', 'section_code', 'admin_entity_code'] 
parties_codes = list(range(1,31))
parties_votes = [str(x) + '_votes' for x in parties_codes]
zipped_thing = list(zip(parties_codes, parties_votes))
list(chain.from_iterable(zipped_thing))

len(initial_fields + parties_codes)
    Полета:
  1) № формуляр
  2) Пълен код на секция(код на район(2), община(2), адм. район(2), секция(3));
  3) Идентификатор на административна единица, за която се отнася протокола(община, кметство, район)
Следват гласовете за всяка партия, коалиция, инициативен комитет, според съответната номенклатура (в ЦИК или РИК), като данните са в последователност № П/К/ИК;действителни гласове


read_parties(PARTIES_LINK).pipe(add_party_alias)
read_sections(SECTIONS_LINK).head()

len(read_votes(VOTES_LINK).columns)
read_votes(VOTES_LINK)

test_s = "32;022300017;2;1;77;2;1;3;0;4;1;5;1;6;1;7;2;8;0;9;1;10;0;11;0;12;0;13;0;14;0;15;2;16;0;17;0;18;0;19;0;20;0;22;0;23;1;24;42;25;1;26;0;27;0;28;2;29;0"
test_s.count(";")

pd.DataFrame(read_votes(VOTES_LINK).votes_dict[0], index = [0]).T.reset_index()

import csv

with open(VOTES_LINK) as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=';')
    line_count = 0
    results_list = []
    for row in csv_reader:
        while line_count < 5:
            n_form = row[0]
            section_code = row[1]
            admin_entity_code = row[2]

            parties_iter = iter(row[3:])
            parties_dict = dict(zip(parties_iter, parties_iter))
            results_list.append([n_form, section_code, admin_entity_code, parties_dict])
            line_count += 1


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

interim = read_votes(VOTES_LINK)