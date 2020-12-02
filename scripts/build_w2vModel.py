## coding: utf-8
'''
This python file is used to tranfer the words in corpus to vector, and save the word2vec model under the path 'w2v_model'.
'''

from gensim.models.word2vec import Word2Vec
import pickle
import os
import gc
import pandas as pd
from nltk.tokenize import word_tokenize
import nltk as nl
from sklearn.linear_model import LogisticRegression

def generate_w2vModel(decTokenFlawPath, w2vModelPath):
    df = pd.read_csv(decTokenFlawPath)
    methodTitles = df['method'].values
    df = [word_tokenize(_method) for _method in methodTitles]
    # print("training...")
    # model = Word2Vec(df, size=300, alpha=0.01, window=5, min_count=0, max_vocab_size=None, sample=0.001, seed=1, workers=1, min_alpha=0.0001, sg=1, hs=0, negative=10, iter=5)
    # model.save('w2vSource.pkl')

    print("\nevaluating...")
    model = Word2Vec.load('w2vSource.pkl')

    clf = LogisticRegression(random_state=0, solver='lbfgs', multi_class='multinomial').fit(model.wv.syn0, Y_dataset[:max_dataset_size])


    
def main():
    dec_tokenFlaw_path = 'E:\\apply\\york\\Courses\\EECS 6444\\final project\\source\\coreutils.csv'
    w2v_model_path = "E:\\apply\\york\\Courses\\EECS 6444\\final project\\source\\models\\" 

 
if __name__ == "__main__":
    main()
