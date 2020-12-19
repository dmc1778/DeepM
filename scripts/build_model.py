
import csv
import pandas as pd
from keras.callbacks import ModelCheckpoint, TensorBoard
from keras.layers import Input, Dense
from tensorflow.keras import regularizers
from keras.models import Model
from keras.datasets import mnist
from sklearn.model_selection import train_test_split, StratifiedKFold
import numpy as np
from keras.preprocessing.text import Tokenizer
import matplotlib.pyplot as plt

import collections
import glob
import os
import pandas as pd
from itertools import combinations
import random


# getting list of
all_path = []
for root, dir, _file in os.walk('./datasets'):
    for project in dir:
        current_project = os.path.join(
            './datasets', project)
        for ds in os.listdir(current_project):
            current_sub_ver = os.path.join(current_project, ds)
            all_path.append(current_sub_ver)

comb_path = combinations(all_path, 2)
comb_path = list(comb_path)
print(len(comb_path))
comb_path = random.sample(comb_path, 2)

pair = [
    ['./datasets/linux/linux-5.8.csv',
        './datasets/coreutils/coreutils-8.31.csv'],
    ['./datasets/linux/linux-5.9.csv',
        './datasets/coreutils/coreutils-8.33.csv'],
    ['./datasets/linux/linux-5.10.csv',
        './datasets/coreutils/coreutils-8.31.csv'],
    ['./datasets/linux/linux-5.8.csv',
        './datasets/findutils/findutils-4.1.20.csv'],
    ['./datasets/linux/linux-5.9.csv',
        './datasets/findutils/findutils-4.2.18.csv'],
    ['./datasets/linux/linux-5.10.csv',
        './datasets/findutils/findutils-4.7.0.csv'],
    ['./datasets/linux/linux-5.8.csv',
        './datasets/make/make-4.2.csv'],
    ['./datasets/linux/linux-5.9.csv',
        './datasets/make/make-4.2.93.csv'],
    ['./datasets/linux/linux-5.10.csv',
        './datasets/make/make-4.3.csv'],
    ['./datasets/xorg/xorg-1.20.9.csv',
        './datasets/coreutils/coreutils-8.31.csv'],
    ['./datasets/postgres/postgres-11.10.csv',
        './datasets/findutils/findutils-4.12.0.csv'],
    ['./datasets/xorg/xorg-1.20.10.csv',
        './datasets/make/make-4.2.csv'],
    ['./datasets/postgres/postgres-11.10.csv',
        './datasets/make/make-4.3.csv'],
    ['./datasets/xen/xen-4.13.2.csv',
        './datasets/make/make-4.2.csv'],
    ['./datasets/xen/xen-4.13.2.csv',
        './datasets/make/make-4.3.csv'],
    ['./datasets/xen/xen-4.14.0.csv',
        './datasets/make/make-4.2.csv'],
    ['./datasets/xen/xen-4.13.2.csv',
        './datasets/coreutils/coreutils-8.31.csv'],
    ['./datasets/xen/xen-4.13.2.csv',
        './datasets/make/make-4.2.csv'],
    ['./datasets/xen/xen-4.13.2.csv',
        './datasets/findutils/findutils-4.2.18.csv'],
    ['./datasets/xorg/xorg-1.19.7.csv',
        './datasets/coreutils/coreutils-8.31.csv'],
    ['./datasets/xorg/xorg-1.20.10.csv',
        './datasets/coreutils/coreutils-8.33.csv'],
    ['./datasets/xorg/xorg-1.19.7.csv', './datasets/coreutils/coreutils-8.31.csv']]


CPDP_path = './results_CNN/CPDP/cpdp.csv'
plot_path = './results_CNN/train_validation_plots/'
embedding_dim_plots = './results_CNN/embedding_dim_plots/'


def write_csv(data_obj):
    with open(CPDP_path, 'w', newline='') as csv_file:
        wr = csv.writer(csv_file)
        for val in data_obj:
            wr.writerow(val)
        csv_file.close()


header = ['Tr', 'Ts', 'Precision', 'Recall', 'F1', 'AUC']

temp_result = [header]

for index, pair in enumerate(comb_path):
    name1 = os.path.basename(pair[0])
    name2 = os.path.basename(pair[1])

    print(name1, name2)

    train_df = pd.read_csv(pair[0])
    test_df = pd.read_csv(pair[1])

    global_data = pd.concat([train_df, test_df], ignore_index=True)
    global_data_train, global_data_test, global_y, global_x = train_test_split(
        global_data.iloc[:, 0], global_data.iloc[:, 1], test_size=1, random_state=1000)

    tokenizer = Tokenizer(num_words=5000)
    tokenizer.fit_on_texts(global_data_train)

    # Adding 1 because of reserved 0 index
    vocab_size = len(tokenizer.word_index) + 1

    _methods = train_df['method']
    _status = train_df['status']

    sentences_train, sentences_test, y_train, y_test = train_test_split(
        _methods, _status, test_size=0.45, random_state=1000)

    plt.style.use('ggplot')

    def plot_history(history, setting_):
        acc = history.history['accuracy']
        val_acc = history.history['val_accuracy']
        loss = history.history['loss']
        val_loss = history.history['val_loss']
        x = range(1, len(acc) + 1)

        plt.figure(figsize=(12, 5))
        plt.subplot(1, 2, 1)
        plt.plot(x, acc, 'b', label='Training acc')
        plt.plot(x, val_acc, 'r', label='Validation acc')
        plt.title('Training and validation accuracy')
        plt.legend()
        # plt.savefig(plot_path + 'accuract' +setting_+'.png')
        plt.subplot(1, 2, 2)
        plt.plot(x, loss, 'b', label='Training loss')
        plt.plot(x, val_loss, 'r', label='Validation loss')
        plt.title('Training and validation loss')
        plt.legend()
        plt.savefig(plot_path + 'loss' + setting_+'.png')

    def plot_embedding_dim(f1, auc, ds_name):
        x = range(1, len(f1) + 1)
        plt.figure(figsize=(12, 5))
        plt.subplot(1, 2, 1)
        plt.plot(x, f1, 'b', label='F1 Score')
        plt.plot(x, auc, 'r', label='AUC')
        plt.title('Embedding dimension vs classification performance')
        plt.legend()
        plt.savefig(embedding_dim_plots+ds_name+'.png')

        # tokenizer = Tokenizer(num_words=5000)
        # tokenizer.fit_on_texts(sentences_train)

    X_train = tokenizer.texts_to_sequences(sentences_train)
    X_test = tokenizer.texts_to_sequences(sentences_test)

    # Adding 1 because of reserved 0 index
    vocab_size = len(tokenizer.word_index) + 1

    from keras.preprocessing.sequence import pad_sequences

    maxlen = 100

    X_train = pad_sequences(X_train, padding='post', maxlen=maxlen)
    X_test = pad_sequences(X_test, padding='post', maxlen=maxlen)

    # tokenizer = Tokenizer(num_words=5000)
    # tokenizer.fit_on_texts(test_df.iloc[:, 0])

    test_data = tokenizer.texts_to_sequences(test_df.iloc[:, 0])

    # Adding 1 because of reserved 0 index
    vocab_size_t = len(tokenizer.word_index) + 1

    size_t = []
    for el in test_data:
        size_t.append(len(el))

    maxlen = 100
    X = pad_sequences(test_data, padding='post', maxlen=maxlen)

    from sklearn.metrics import classification_report
    from keras import backend as K
    from keras import optimizers
    from keras.models import Sequential
    from keras import layers

    def recall_m(y_true, y_pred):
        threshold_value = 0.5
        # Adaptation of the "round()" used before to get the predictions. Clipping to make sure that the predicted raw values are between 0 and 1.
        y_pred = K.cast(K.greater(K.clip(y_pred, 0, 1),
                                  threshold_value), K.floatx())
        # Compute the number of true positives. Rounding in prevention to make sure we have an integer.
        true_positives = K.round(K.sum(K.clip(y_true * y_pred, 0, 1)))
        # Compute the number of positive targets.
        possible_positives = K.sum(K.clip(y_true, 0, 1))
        recall_ratio = true_positives / (possible_positives + K.epsilon())
        return recall_ratio

    def precision_m(y_true, y_pred):
        threshold_value = 0.5
        # Adaptation of the "round()" used before to get the predictions. Clipping to make sure that the predicted raw values are between 0 and 1.
        y_pred = K.cast(K.greater(K.clip(y_pred, 0, 1),
                                  threshold_value), K.floatx())
        # Compute the number of true positives. Rounding in prevention to make sure we have an integer.
        true_positives = K.round(K.sum(K.clip(y_true * y_pred, 0, 1)))
        # count the predicted positives
        predicted_positives = K.sum(y_pred)
        # Get the precision ratio
        precision_ratio = true_positives / (predicted_positives + K.epsilon())
        return precision_ratio

    def f1_m(y_true, y_pred):
        precision = precision_m(y_true, y_pred)
        recall = recall_m(y_true, y_pred)
        return 2*((precision*recall)/(precision+recall+K.epsilon()))

    f1_store = []
    auc_store = []
    units = [2, 5, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
    for embedding_dim in range(len(units)):
        model = Sequential()
        model.add(layers.Embedding(vocab_size, 30, input_length=maxlen))
        model.add(layers.Conv1D(32, 5, activation='relu'))
        model.add(layers.GlobalMaxPooling1D())
        #model.add(layers.Dense(20, activation='relu'))
        model.add(layers.Dense(units[embedding_dim], activation='relu'))
        model.add(layers.Dense(1, activation='sigmoid'))
        sgd = optimizers.Adagrad(lr=0.01, epsilon=1e-08, decay=0.0)
        model.compile(optimizer=sgd,
                      loss='binary_crossentropy',
                      metrics=['accuracy', f1_m, precision_m, recall_m])

        model.summary()

        history = model.fit(X_train, y_train,
                            epochs=60,
                            verbose=False,
                            validation_data=(X_test, y_test),
                            batch_size=64)

        loss, accuracy, f1_score, precision, recall = model.evaluate(
            X_train, y_train, verbose=False)
        print("Training Accuracy: {:.4f}".format(accuracy))
        loss, accuracy, f1_score, precision, recall = model.evaluate(
            X_test, y_test, verbose=False)
        print("Testing Accuracy:  {:.4f}".format(accuracy))
        plot_history(history, name1+'-->'+name2+str(units[embedding_dim]))

        loss, accuracy, f1_score, precision, recall = model.evaluate(
            X, test_df.iloc[:, 1], verbose=True, batch_size=32)
        print("testing Accuracy: {:.4f}".format(accuracy))
        print("testing F1 Score: {:.4f}".format(f1_score))
        print("testing Precision: {:.4f}".format(precision))
        print("testing Recall: {:.4f}".format(recall))

        predictions = model.predict(X, batch_size=32, verbose=True)

        threshold_fixed = 0.5

        pred_y = [1 if e >= threshold_fixed else 0 for e in predictions]
        report = classification_report(
            test_df.iloc[:, 1], pred_y, output_dict=True)
        print(round(report['1']['precision'], 2))
        print(round(report['1']['recall'], 2))
        print(round(report['1']['f1-score'], 2))

        from sklearn import metrics

        fpr, tpr, thresholds = metrics.roc_curve(
            test_df.iloc[:, 1], pred_y, pos_label=1)
        metrics.auc(fpr, tpr)

        temp_result.append([name1, name2, round(report['1']['precision'], 2), round(
            report['1']['recall'], 2), round(report['1']['f1-score'], 2), metrics.auc(fpr, tpr)])

        write_csv(temp_result)

        f1_store.append(round(report['1']['f1-score'], 2))
        auc_store.append(metrics.auc(fpr, tpr))

    plot_embedding_dim(f1_store, auc_store, name1+'-->'+name2)


