import os
import fnmatch
import pandas as pd
from nltk.tokenize import word_tokenize
import csv
import string
from gensim.models import Word2Vec, KeyedVectors

base_path = "./sliced_methods"

out_path = "./mutated_methods"


class ProcessMethods:
    def __init__(self) -> None:
        self.UMA = False
        self.FMA = False
        self.FHM = False

    def exec(self):
        self.list_all_files()
        self.CustomeTokenizer()

    def w2v(self, df):
        methodTitles = df['method'].values
        new_df = [word_tokenize(_method) for _method in methodTitles]
        model = Word2Vec(new_df, min_count=1, size=32)
        print(len(model.wv.syn0))
        return self

    def write_file(self, project_name, _file):
        _path = out_path+"\\"+project_name+".csv"
        _file.to_csv(_path, encoding='utf-8', index=False)
        # with open(_path, 'w') as f:
        #     writer = csv.writer(f)
        #     for row in _file:
        #         writer.writerow(str(row).translate(string.maketr('', ''), '[]\''))
        return self

    def load_file(self, file_addr):
        return open(file_addr, 'r').read().replace('\n', '')

    def CustomeTokenizer(self, _dir):
        raw_txt = self.load_file(_dir)
        return word_tokenize(raw_txt)

    def list_all_files(self):
        for root, direname, _ in os.walk(base_path):
            temp = []
            for project in direname:
                subdir = os.path.join(root, project)
                listDir = os.listdir(subdir)
                for _method in listDir:
                    working_dir = os.path.join(subdir, _method)
                    for c_files in os.walk(working_dir):
                        for _file_i_ in c_files[2]:
                            _file_i_ = os.path.join(working_dir, _file_i_)
                            myfile = self.load_file(_file_i_)
                            # tokenized = self.CustomeTokenizer(_file_i_)
                            # tokenized = str(tokenized)[1 : -1]
                            temp.append((myfile, _label))
                df_i = pd.DataFrame(temp, columns=('method', 'status'))
                self.write_file(project, df_i)
                # self.w2v(df_i)
                df_i = pd.DataFrame(None)
                temp = []


if __name__ == '__main__':
    _pm = ProcessMethods()
    _pm.exec()
