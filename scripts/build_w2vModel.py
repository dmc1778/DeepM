
from gensim.models.word2vec import Word2Vec
import pickle
import os
import gc
import pandas as pd
from nltk.tokenize import word_tokenize


def generate_w2vModel(df, w2vModelPath):
    print("training...")
    method_blocks = df['method'].values
    df = [word_tokenize(_method) for _method in method_blocks]
    model = Word2Vec(df, size=30, alpha=0.01, window=5, min_count=1,
                     max_vocab_size=None, sample=0.001, seed=1, workers=1, min_alpha=0.0001, sg=1, hs=0, negative=10, iter=5)
    model.save(w2vModelPath)
    # dl_corpus = [[model[_token] for _token in _method]
    #              for _method in df]
    # print(len(dl_corpus[0]))
    # print()


def evaluate_w2vModel(w2vModelPath):
    print("\nevaluating...")
    model = Word2Vec.load(w2vModelPath)
    word_vectors = model.wv
    print("Number of word vectors: {}".format(len(word_vectors.vocab)))

    MAX_NB_WORDS = len(word_vectors.vocab)
    MAX_SEQUENCE_LENGTH = 100

    word_index = {t[0]: i+1 for i,
                  t in enumerate(vocab.most_common(MAX_NB_WORDS))}

    print(word_index)


def main():
    dec_tokenFlaw_path = './datasets/linux.csv'
    df = pd.read_csv(dec_tokenFlaw_path, sep=',', names=['method', 'status'])
    w2v_model_path = "./models"
    if not os.path.exists(w2v_model_path):
        os.makedirs(w2v_model_path)
    w2v_model_path = os.path.join(w2v_model_path, 'linuxVectors')
    generate_w2vModel(df, w2v_model_path)
    evaluate_w2vModel(w2v_model_path)
    print("success!")


if __name__ == "__main__":
    main()
