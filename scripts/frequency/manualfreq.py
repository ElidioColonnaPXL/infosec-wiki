# for PE Security Essentials "Cracking the Encryption"
# Script om een eenvoudige substitutie-cipher te analyseren en manueel te ontcijferen

# opties:
# -o  --> toont de originele ciphertext uit cypher.txt
# -f  --> berekent letterfrequenties
# -d  --> start interactieve decryptie

import argparse                     # voor command line argumenten
from collections import Counter     # om frequenties van letters te tellen
import string                       # bevat alfabet constanten

# pad naar de ciphertext
FILE = "text/cypher.txt"

# standaard letterfrequenties in Engels (percentage)
english_freq = {
    'e': 12.70, 't': 9.06, 'a': 8.17, 'o': 7.51, 'i': 6.97,
    'n': 6.75, 's': 6.33, 'h': 6.09, 'r': 5.99, 'd': 4.25,
    'l': 4.03, 'c': 2.78, 'u': 2.76, 'm': 2.41, 'w': 2.36,
    'f': 2.23, 'g': 2.02, 'y': 1.97, 'p': 1.93, 'b': 1.49,
    'v': 0.98, 'k': 0.77, 'j': 0.15, 'x': 0.15, 'q': 0.10,
    'z': 0.07
}


# leest de ciphertext uit het bestand
def load_text():
    with open(FILE, "r", encoding="utf-8") as f:
        return f.read()


# toont de originele ciphertext op het scherm
def show_original(text):
    print("\nOriginal ciphertext:\n")
    print(text)


# berekent letterfrequenties van de ciphertext
def frequency(text):
    # neem enkel letters uit het alfabet
    letters = [c for c in text.lower() if c in string.ascii_lowercase]

    # tel hoe vaak elke letter voorkomt
    freq = Counter(letters)
    total = sum(freq.values())

    # sorteer Engelse frequenties van hoog naar laag
    english_sorted = sorted(english_freq.items(), key=lambda x: x[1], reverse=True)

    print("\nCipher | CipherFreq | Guess | EngFreq")
    print("--------------------------------------")

    # sorteer ciphertext letters op frequentie
    cipher_sorted = freq.most_common()

    # toon vergelijking ciphertext vs Engels
    for i, (letter, count) in enumerate(cipher_sorted):
        perc = (count / total) * 100

        # probeer een gok te maken op basis van Engelse frequenties
        if i < len(english_sorted):
            guess_letter, eng_val = english_sorted[i]
            print(f"{letter:>5} | {perc:>10.2f} | {guess_letter:>5} | {eng_val:>7.2f}")
        else:
            print(f"{letter:>5} | {perc:>10.2f}")


# voert de decryptie uit volgens een mapping
# vb: {'x':'e', 'q':'t'}
def decrypt(text, mapping):
    result = []

    for ch in text:
        low = ch.lower()

        # als letter in mapping zit -> vervang door plaintext letter
        if low in mapping:
            dec = mapping[low]

            # behoud hoofdletters
            if ch.isupper():
                result.append(dec.upper())
            else:
                result.append(dec)

        # als het een letter is maar nog niet gemapped -> toon _
        elif ch.isalpha():
            result.append("_")

        # andere tekens blijven hetzelfde (spaties, punten, ...)
        else:
            result.append(ch)

    return "".join(result)


# interactieve decryptie
# gebruiker kan letter per letter vervangen
def interactive_decrypt(text):
    mapping = {}

    while True:
        # toon huidige mapping
        print("\nCurrent mapping:", mapping)

        # toon huidige decryptie
        print("\nDecrypted text:\n")
        print(decrypt(text, mapping))

        try:
            # vraag volgende cipher letter
            cipher_letter = input("\nnext letter: ").strip().lower()

            # stop als gebruiker 'exit' typt
            if cipher_letter == "exit":
                break

            # vraag naar welke plaintext letter
            plain_letter = input("to: ").strip().lower()

            # controleer of input geldig is
            if cipher_letter in string.ascii_lowercase and plain_letter in string.ascii_lowercase:
                mapping[cipher_letter] = plain_letter
            else:
                print("Invalid input.")

        # ctrl+c stopt het programma
        except KeyboardInterrupt:
            break


# hoofdprogramma
def main():
    parser = argparse.ArgumentParser()

    # command line opties
    parser.add_argument("-o", action="store_true", help="show original ciphertext")
    parser.add_argument("-f", action="store_true", help="frequency analysis")
    parser.add_argument("-d", action="store_true", help="interactive decrypt")

    args = parser.parse_args()

    # laad ciphertext
    text = load_text()

    # toon originele tekst
    if args.o:
        show_original(text)

    # voer frequentie analyse uit
    elif args.f:
        frequency(text)

    # start interactieve decryptie
    elif args.d:
        interactive_decrypt(text)

    # geen optie gekozen
    else:
        print("Use -o for original text, -f for frequency analysis, or -d for decrypting.")


# startpunt van het script
if __name__ == "__main__":
    main()