
def generate_corpus(w2vModelPath, samples):
    model = Word2Vec.load(w2vModelPath)
    print("begin generate input...")
    dl_corpus = [[model[word] for word in sample] for sample in samples]
    print("generate input success...")

    return dl_corpus


def main():
    w2vModelPath = './models/linuxVectors'
    generate_corpus(w2vModelPath)


if __name__ == "__main__":
    main()
