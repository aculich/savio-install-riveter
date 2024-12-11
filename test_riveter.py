import spacy

try:
    # Load SpaCy model
    import neuralcoref
    nlp = spacy.load("en_core_web_sm")

    # Add NeuralCoref to pipeline
    neuralcoref.add_to_pipe(nlp)

    # Test Coreference Resolution
    doc = nlp("My sister has a dog. She loves him.")
    print("Coreferences:", doc._.coref_clusters)

except ImportError as e:
    print(f"ImportError: {e}")
    raise
except Exception as e:
    print(f"Unexpected error: {e}")
    raise
