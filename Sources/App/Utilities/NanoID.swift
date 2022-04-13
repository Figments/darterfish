//
//  NanoID.swift
//
//  Created by Anton Lovchikov on 05/07/2018.
//  Copyright © 2018 Anton Lovchikov. All rights reserved.
//
//
// MIT License
//
// Copyright (c) 2018 Anton Lovchikov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

/// USAGE
///
/// Nano ID with default alphabet (0-9a-zA-Z_~) and length (21 chars)
/// let id = NanoID.new()
///
/// Nano ID with default alphabet and given length
/// let id = NanoID.new(12)
///
/// Nano ID with given alphabet and length
/// let id = NanoID.new(alphabet: .uppercasedLatinLetters, size: 15)
///
/// Nano ID with preset custom parameters
/// let nanoID = NanoID(alphabet: .lowercasedLatinLetters,.numbers, size:10)
/// let idFirst = nanoID.new()
/// let idSecond = nanoID.new()
class NanoID {

    // Shared Parameters
    private var size: Int
    private var alphabet: String

    /// Inits an instance with Shared Parameters
    init(alphabet: NanoIDAlphabet..., size: Int) {
        self.size = size
        self.alphabet = NanoIDHelper.parse(alphabet)
    }

    /// Generates a Nano ID using Shared Parameters
    func new() -> String {
        return NanoIDHelper.generate(from: alphabet, of: size)
    }

    // Default Parameters
    private static let defaultSize = 21
    private static let defaultAphabet = NanoIDAlphabet.urlSafe.toString()

    /// Generates a Nano ID using Default Parameters
    static func new() -> String {
        return NanoIDHelper.generate(from: defaultAphabet, of: defaultSize)
    }

    /// Generates a Nano ID using given occasional parameters
    static func new(alphabet: NanoIDAlphabet..., size: Int) -> String {
        let charactersString = NanoIDHelper.parse(alphabet)
        return NanoIDHelper.generate(from: charactersString, of: size)
    }

    /// Generates a Nano ID using Default Alphabet and given size
    static func new(_ size: Int) -> String {
        return NanoIDHelper.generate(from: NanoID.defaultAphabet, of: size)
    }
}

fileprivate class NanoIDHelper {

    /// Parses input alphabets into a string
    static func parse(_ alphabets: [NanoIDAlphabet]) -> String {

        var stringCharacters = ""

        for alphabet in alphabets {
            stringCharacters.append(alphabet.toString())
        }

        return stringCharacters
    }

    /// Generates a Nano ID using given parameters
    static func generate(from alphabet: String, of length: Int) -> String {
        var nanoID = ""

        for _ in 0..<length {
            let randomCharacter = NanoIDHelper.randomCharacter(from: alphabet)
            nanoID.append(randomCharacter)
        }

        return nanoID
    }

    /// Returns a random character from a given string
    static func randomCharacter(from string: String) -> Character {
        let randomNum = Int(arc4random_uniform(UInt32(string.count)))
        let randomIndex = string.index(string.startIndex, offsetBy: randomNum)
        return string[randomIndex]
    }
}

enum NanoIDAlphabet {
    case urlSafe
    case uppercasedLatinLetters
    case lowercasedLatinLetters
    case numbers

    func toString() -> String {
        switch self {
        case .uppercasedLatinLetters, .lowercasedLatinLetters, .numbers:
            return self.chars()
        case .urlSafe:
            return ("\(NanoIDAlphabet.uppercasedLatinLetters.chars())\(NanoIDAlphabet.lowercasedLatinLetters.chars())\(NanoIDAlphabet.numbers.chars())~_")
        }
    }

    private func chars() -> String {
        switch self {
        case .uppercasedLatinLetters:
            return "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        case .lowercasedLatinLetters:
            return "abcdefghijklmnopqrstuvwxyz"
        case .numbers:
            return "1234567890"
        default:
            return ""
        }
    }
}