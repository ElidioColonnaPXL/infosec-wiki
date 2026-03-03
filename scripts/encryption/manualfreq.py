# for PE Security Essentials "Cracking the Encryption"

# options
# -o -->> display original text in cypher.txt
# -f -->> calculates frequesties in text
# -d -->> start manual decryption

import argparse
from collections import Counter
import string

FILE = "text/cypher.txt"

# Standard English frequencies
english_freq = {
    'e': 12.70, 't': 9.06, 'a': 8.17, 'o': 7.51, 'i': 6.97,
    'n': 6.75, 's': 6.33, 'h': 6.09, 'r': 5.99, 'd': 4.25,
    'l': 4.03, 'c': 2.78, 'u': 2.76, 'm': 2.41, 'w': 2.36,
    'f': 2.23, 'g': 2.02, 'y': 1.97, 'p': 1.93, 'b': 1.49,
    'v': 0.98, 'k': 0.77, 'j': 0.15, 'x': 0.15, 'q': 0.10,
    'z': 0.07
}


def load_text():
    with open(FILE, "r", encoding="utf-8") as f:
        return f.read()


def show_original(text):
    print("\nOriginal ciphertext:\n")
    print(text)


def frequency(text):
    letters = [c for c in text.lower() if c in string.ascii_lowercase]
    freq = Counter(letters)
    total = sum(freq.values())

    english_sorted = sorted(english_freq.items(), key=lambda x: x[1], reverse=True)

    print("\nCipher | CipherFreq | Guess | EngFreq")
    print("--------------------------------------")

    cipher_sorted = freq.most_common()

    for i, (letter, count) in enumerate(cipher_sorted):
        perc = (count / total) * 100

        if i < len(english_sorted):
            guess_letter, eng_val = english_sorted[i]
            print(f"{letter:>5} | {perc:>10.2f} | {guess_letter:>5} | {eng_val:>7.2f}")
        else:
            print(f"{letter:>5} | {perc:>10.2f}")


def decrypt(text, mapping):
    result = []

    for ch in text:
        low = ch.lower()

        if low in mapping:
            dec = mapping[low]

            if ch.isupper():
                result.append(dec.upper())
            else:
                result.append(dec)

        elif ch.isalpha():
            result.append("_")
        else:
            result.append(ch)

    return "".join(result)


def interactive_decrypt(text):
    mapping = {}

    while True:
        print("\nCurrent mapping:", mapping)
        print("\nDecrypted text:\n")
        print(decrypt(text, mapping))

        try:
            cipher_letter = input("\nnext letter: ").strip().lower()

            if cipher_letter == "exit":
                break

            plain_letter = input("to: ").strip().lower()

            if cipher_letter in string.ascii_lowercase and plain_letter in string.ascii_lowercase:
                mapping[cipher_letter] = plain_letter
            else:
                print("Invalid input.")

        except KeyboardInterrupt:
            break


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-o", action="store_true", help="show original ciphertext")
    parser.add_argument("-f", action="store_true", help="frequency analysis")
    parser.add_argument("-d", action="store_true", help="interactive decrypt")

    args = parser.parse_args()

    text = load_text()

    if args.o:
        show_original(text)

    elif args.f:
        frequency(text)

    elif args.d:
        interactive_decrypt(text)

    else:
        print("Use -o for original text, -f for frequency analysis, or -d for decrypting.")


if __name__ == "__main__":
    main()