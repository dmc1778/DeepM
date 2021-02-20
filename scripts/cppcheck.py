import os
import sys
import argparse
from graphviz import Digraph
import csv
import random
from sklearn.metrics import classification_report, confusion_matrix
import numpy as np
from nltk.tokenize import word_tokenize, WhitespaceTokenizer
import itertools
import re
from sklearn import metrics


def null_identifier(line):
    return WhitespaceTokenizer().tokenize(line)


def read_csv(csv_file_path):
    data = []
    with open(csv_file_path, encoding='utf-8') as fp:
        header = fp.readline()
        header = header.strip()
        h_parts = [hp.strip() for hp in header.split('\t')]
        for line in fp:
            line = line.strip()
            instance = {}
            lparts = line.split('\t')
            for i, hp in enumerate(h_parts):
                if i < len(lparts):
                    content = lparts[i].strip()
                else:
                    content = ''
                instance[hp] = content
            data.append(instance)
        return data


def read_criteria_file(file_path):
    # file_path = file_path.replace('.c.c.csv', '.c.csv')
    # file_path = file_path.replace('.c.c.csv', '.c.csv')
    with open(file_path, 'r') as fp:
        csvreader = csv.reader(fp)
        rows = []
        for row in csvreader:
            rows.append(row)
    return rows


def read_code_file(file_path):
    code_lines = {}
    with open(file_path) as fp:
        for ln, line in enumerate(fp):
            assert isinstance(line, str)
            line = line.strip()
            if '//' in line:
                line = line[:line.index('//')]
            code_lines[ln + 1] = line
        return code_lines


if __name__ == '__main__':
    cppcheck_of_methods_path = './cppcheck_results'

    for root, dirname, filename in os.walk(cppcheck_of_methods_path):

        for sub_dir in filename:
            TP = 0
            FP = 0
            FN = 0
            _cwd = os.path.join(cppcheck_of_methods_path, sub_dir)
            cppcheckres = read_criteria_file(_cwd)
            for item in cppcheckres:
                if str(476) in item[1]:
                    TP += 1
                elif str(0) in item[1]:
                    FN += 1
                else:
                    FP += 1
            precision = TP / (TP + FP)
            recall = TP / (TP + FN)
            print("Prediction performance for: %s" % (sub_dir))
            print("Precision: %5.2f" % (precision))
            print("Recall: %5.2f" % (recall))
            print("F1 score: %5.2f" %
                  (2*((precision*recall)/(precision+recall))))
