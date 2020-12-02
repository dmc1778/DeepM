from transformers import BertTokenizer
import pandas as pd
from keras.preprocessing.sequence import pad_sequences
from sklearn.model_selection import train_test_split
from torch.utils.data import TensorDataset, DataLoader, RandomSampler, SequentialSampler
from transformers import BertForSequenceClassification, AdamW, BertConfig
from transformers import BertModel
from transformers import get_linear_schedule_with_warmup
import torch
import tensorflow as tf
import numpy as np
import time
import datetime
import random


tokenizer = BertTokenizer.from_pretrained(
    'bert-base-uncased', do_lower_case=False)


device = torch.device("cpu")

def format_time(elapsed):
    '''
    Takes a time in seconds and returns a string hh:mm:ss
    '''
    # Round to the nearest second.
    elapsed_rounded = int(round((elapsed)))
    
    # Format as hh:mm:ss
    return str(datetime.timedelta(seconds=elapsed_rounded))

def flat_accuracy(preds, labels):
    pred_flat = np.argmax(preds, axis=1).flatten()
    labels_flat = labels.flatten()
    return np.sum(pred_flat == labels_flat) / len(labels_flat)

def data_final_prep(input_ids, labels, attention_masks):
    train_inputs, validation_inputs, train_labels, validation_labels = train_test_split(
        input_ids, labels, random_state=2018, test_size=0.1)

    train_masks, validation_masks, _, _ = train_test_split(
        attention_masks, labels, random_state=2018, test_size=0.1)

    return train_inputs, validation_inputs, train_labels, validation_labels,  train_masks, validation_masks


def make_attention(input_ids):
    attention_masks = []

    for _method in input_ids:
        att_mask = [int(token_id > 0) for token_id in _method]
        attention_masks.append(att_mask)
    return attention_masks


def pad_seqs(input_ids):
    MAX_LEN = 128

    input_ids = pad_sequences(
        input_ids, maxlen=MAX_LEN, dtype="long", value=0, truncating="post", padding="post")
    return input_ids


def tokenize_all_methods(data):
    input_ids = []
    lengths = []

    for _method in data:
        if ((len(input_ids) % 20000) == 0):
            print('Read {:,} methods'.format(len(input_ids)))

        encoded_method = tokenizer.encode(
            _method,
            add_special_tokens=False,
            max_length=128

        )

        input_ids.append(encoded_method)
        lengths.append(len(encoded_method))
    print('Done')
    print('{:>10,} methods'.format(len(input_ids)))
    return input_ids


def read_data(_path):
    df = pd.read_csv(_path)
    return df


def main():
    _path = "E:\\apply\\york\\Courses\\EECS 6444\\final project\\source\\coreutils.csv"
    data = read_data(_path)
    _methods = data.iloc[:, 0]
    labels = data.iloc[:, 1]

    input_ids = tokenize_all_methods(_methods)
    input_ids = pad_seqs(input_ids)
    attention_masks = make_attention(input_ids)
    train_inputs, validation_inputs, train_labels, validation_labels,  train_masks, validation_masks = data_final_prep(
        input_ids, labels, attention_masks)
    
    train_inputs = torch.tensor(train_inputs)
    validation_inputs = torch.tensor(validation_inputs)

    train_labels = torch.tensor(train_labels.values)
    validation_labels = torch.tensor(validation_labels.values)

    train_masks = torch.tensor(train_masks)
    validation_masks = torch.tensor(validation_masks)

    batch_size = 32

    # Create the DataLoader for our training set.
    train_data = TensorDataset(train_inputs, train_masks, train_labels)
    train_sampler = RandomSampler(train_data)
    train_dataloader = DataLoader(train_data, sampler=train_sampler, batch_size=batch_size)

    validation_data = TensorDataset(validation_inputs, validation_masks, validation_labels)
    validation_sampler = SequentialSampler(validation_data)
    validation_dataloader = DataLoader(validation_data, sampler=validation_sampler, batch_size=batch_size)

    model = BertForSequenceClassification.from_pretrained(
        "bert-base-uncased",
        num_labels = 2, 
                      
        output_attentions = False, 
        output_hidden_states = False,
    )

    optimizer = AdamW(model.parameters(),
                  lr = 2e-5, 
                  eps = 1e-8 
                )

    epochs = 4


    total_steps = len(train_dataloader) * epochs

    scheduler = get_linear_schedule_with_warmup(optimizer, 
                                                num_warmup_steps = 0, 
                                                num_training_steps = total_steps)
    
    seed_val = 42

    random.seed(seed_val)
    np.random.seed(seed_val)
    torch.manual_seed(seed_val)

    loss_values = []

    for epoch_i in range(0, epochs):
        print("")
        print('======== Epoch {:} / {:} ========'.format(epoch_i + 1, epochs))
        print('Training...')


        t0 = time.time()

        total_loss = 0

        model.train()

        for step, batch in enumerate(train_dataloader):

            if step % 40 == 0 and not step == 0:

                elapsed = format_time(time.time() - t0)
            
                print('  Batch {:>5,}  of  {:>5,}.    Elapsed: {:}.'.format(step, len(train_dataloader), elapsed))

    
            b_input_ids = batch[0].to(device)
            b_input_mask = batch[1].to(device)
            b_labels = batch[2].to(device)

            b_input_ids = torch.tensor(b_input_ids).to(device).long()
            b_input_mask = torch.tensor(b_input_mask).to(device).long()
            b_labels = torch.tensor(b_labels).to(device).long()

            model.zero_grad()        

            outputs = model(b_input_ids, 
                        token_type_ids=None, 
                        attention_mask=b_input_mask, 
                        labels=b_labels)
            
            loss = outputs[0]

            total_loss += loss.item()

            loss.backward()

            torch.nn.utils.clip_grad_norm_(model.parameters(), 1.0)

            optimizer.step()

            scheduler.step()

        avg_train_loss = total_loss / len(train_dataloader)            
        
        loss_values.append(avg_train_loss)

        print("")
        print("  Average training loss: {0:.2f}".format(avg_train_loss))
        print("  Training epcoh took: {:}".format(format_time(time.time() - t0)))

        print("")
        print("Running Validation...")

        t0 = time.time()

        model.eval()

        eval_loss, eval_accuracy = 0, 0
        nb_eval_steps, nb_eval_examples = 0, 0

        for batch in validation_dataloader:
            
            batch = tuple(t.to(device) for t in batch)
            
    
            b_input_ids, b_input_mask, b_labels = batch

            b_input_ids = torch.tensor(b_input_ids).to(device).long()
            b_input_mask = torch.tensor(b_input_mask).to(device).long()
            b_labels = torch.tensor(b_labels).to(device).long()
            
            with torch.no_grad():        
                outputs = model(b_input_ids, 
                                token_type_ids=None, 
                                attention_mask=b_input_mask)
            

            logits = outputs[0]

            logits = logits.detach().cpu().numpy()
            label_ids = b_labels.to('cpu').numpy()
         
            tmp_eval_accuracy = flat_accuracy(logits, label_ids)
            
            eval_accuracy += tmp_eval_accuracy

            nb_eval_steps += 1

        print("  Accuracy: {0:.2f}".format(eval_accuracy/nb_eval_steps))
        print("  Validation took: {:}".format(format_time(time.time() - t0)))

    print("")
    print("Training complete!")


if __name__ == '__main__':
    main()
