#!/usr/local/bin/python3
import sys
import string
import re
from os import path

class Letters:
    """
        The class which handles with frequencies of the letters.
    """
    def __init__(self):
        self.letters = {letter:0 for letter in string.ascii_lowercase}
    def increment_letter(self, char):
        if char in self.letters.keys():
            self.letters[char] += 1
        else:
            self.letters[char] = 1
    def add_word(self, word):
        for c in word:
            self.increment_letter(c)
    def __sorted_keys_by_freq__(self):
        return(sorted(self.letters, key=self.letters.get, reverse=True))
    def sorted(self):
        sorted_keys = self.__sorted_keys_by_freq__()
        return({k: self.letters[k] for k in sorted_keys})
    def output_lines(self):
        sorted_keys = self.__sorted_keys_by_freq__()
        return(["{:2}: {}".format(k, self.letters[k]) for k in sorted_keys])

class Words:
    """
        The class which handles with words.
        Attributes:
            counter : <int>
                Total number of the words that are added to object
            counter_unique : <int>
                Total number of the unique
            words : <dict>
                All words that are added to object and their occurance count
                * keys -> all words that are added to object
                * values -> occurance count of the key word
    """
    def __init__(self):
        self.count = 0
        self.count_unique = 0
        self.words = dict()
    def increment_count(self):
        self.count += 1
    def increment_count_unique(self):
        self.count_unique += 1
    def add_word(self, word):
        if word in self.words.keys():
            # if it is already in the dictionary increment it
            self.words[word] += 1
        else:
            # if it is not in the keys create new key
            self.words[word] = 1
            self.increment_count_unique()
        self.increment_count()
    def __sorted_keys_by_freq__(self):
        return(sorted(self.words, key=self.words.get, reverse=True))
    def sorted(self):
        return({k: self.words[k] for k in self.__sorted_keys_by_freq__()})
    def first_x(self, x):
        sorted_keys = self.__sorted_keys_by_freq__()
        return [(k, self.words[k]) for k in sorted_keys[:x]]
    def get_freq(self, word):
        if word in self.words:
            return self.words[word]
        else:
            return None

class Successors:
    """
    The class which handles with successors of words.
    Attributes:
        counter : <int>
            Total number of the words that are added to object
        successors : <dict>
            This attribute is a nested dictionary.
            * keys -> all words that are added to object
            * values -> another dictionary that contains
                        all successors (follower word) of the key word
                        and their occurance count
            Example:
                {"my":{"supper":10, "king":5, "lord":3}}
    """
    def __init__(self):
        self.count = 0
        self.successors = dict()
    def increment_count(self):
        self.count += 1
    def add_successor(self, word, succ):
        if word in self.successors.keys():
            # if the word already exists in the dictionary only add the successor
            if succ in self.successors[word].keys():
                # if the successor already exists in the successors dictionary
                # increment the occurance count
                self.successors[word][succ] += 1
            else:
                # otherwise create successor
                self.successors[word][succ] = 1
        else:
            # if the word is not exist in dictionary create word and
            # add the first successor
            self.successors[word] = {succ: 1}
        self.increment_count()
    def get_successors(self, word):
        # return None if the wanted word is not in the successors
        if word in self.successors:
            return(self.successors[word])
        else:
            return(None)
    def __sorted_keys_by_freq__(self, dic):
        return(sorted(dic, key=dic.get, reverse=True))
    def first_x_successors(self, word, x):
        succs = self.get_successors(word)
        # if wanted word is not existing in word list return None
        if succs:
            sorted_keys = self.__sorted_keys_by_freq__(succs)
            return [(k, succs[k]) for k in sorted_keys[:x]]
        else:
            return None

def custom_split(str):
    seps = '[' + string.whitespace + string.punctuation + ']+'
    return(re.split(seps, str))

def read_all_text(filename):
    with open(filename, "r") as text_file:
        all = text_file.read()
    return(all)

def is_word(str):
    return(str.isalpha())

def return_stats(filename):
    letters = Letters()
    words = Words()
    successors = Successors()
    with open(filename, "r") as text_file:
        all_text = custom_split(text_file.read())
        all_text = [w.lower() for w in all_text if is_word(w)]
        letters.add_word(all_text[0])
        words.add_word(all_text[0])
        for i in range(1, len(all_text)):
            prev_word = all_text[i-1]
            w = all_text[i]
            # if it is word count the letters of it
            letters.add_word(w)
            # if it is word count the word
            words.add_word(w)
            successors.add_successor(prev_word, w)

    return (letters, words, successors)

def output_generator(letters, words, successors, in_fname):
    letter_outs = letters.output_lines()
    first_5_word = words.first_x(5)
    word_succs_outs = []
    word_padding = max(first_5_word, key=lambda x:len(x[0]))[0].__len__() + 1
    for w,f in first_5_word:
        word_succs_outs.append("{:{width}} ({} occurances)".format(w, f, width = word_padding))
        succs = successors.first_x_successors(w, 3)
        succs_padding = max(succs, key=lambda x:len(x[0]))[0].__len__() + 1
        for sw, sf in succs:
            word_succs_outs.append("\t{:{width}} : {}".format(sw, sf, width = succs_padding))
    header = ["Text Statistics of \""+in_fname+"\" File"]
    seperator_line = ["-"*41]
    letter_header = ["~~~~~ Letter Frequencies ~~~~~"]
    word_header = ["~~~~~ Words and Successors ~~~~~"]
    out_list = seperator_line + header + seperator_line + \
                letter_header + letter_outs + seperator_line + \
                word_header + word_succs_outs + seperator_line
    return out_list

def print_stdout(out):
    for line in out:
        print(line)

def print_fout(out_fname, out):
    org_stdout = sys.stdout
    sys.stdout = open("./" + out_fname, "w")
    print_stdout(out)
    sys.stdout = org_stdout

def run_from_pkg(in_fname, out_fname = None):
    # get the statistics about the text file
    letters, words, successors = return_stats(in_fname)
    output_lines = output_generator(letters, words, successors, in_fname)
    print_stdout(output_lines)
    if out_fname:
        print_fout(out_fname, output_lines)

def run_terminal():
    if len(sys.argv)==1:
        print("There is no argument!\n\tUsage: ./text_stats.py <filename>")
        sys.exit()
    elif len(sys.argv) > 3:
        print("Max two arguments are expected! <outfile> is optional.\n\tUsage: ./text_stats.py <filename> <outfile>")
        sys.exit()
    elif not path.isfile(sys.argv[1]):
        print("There is no such a file named", sys.argv[1],"\n\tUsage: ./text_stats.py <filename>")
        sys.exit()
    elif len(sys.argv) == 3:
        out_fname = sys.argv[2]
        out_flag = 1
    else:
        out_flag = 0

    in_fname = sys.argv[1]

    # get the statistics about the text file
    letters, words, successors = return_stats(in_fname)

    output_lines = output_generator(letters, words, successors, in_fname)

    print_stdout(output_lines)

    if out_flag:
        print_fout(out_fname, output_lines)


if __name__ == '__main__':
    run_terminal()
