// javascript
/**
 * TextWrapper Constructor Function
 * Creates an object that provides text wrapping functionality.
 * Primarily designed to handle text wrapping considering both Japanese and English characters.
 * @param {number} charWidth - The width of a single character (e.g., in pixels). This will be treated as the width of a full-width character.
 * @param {number} charHeight - The height of a single line (not used in current logic, but kept).
 */
global.multiTextSplitter = function (charWidth = 8, charHeight = 8) {
    var ret = {
      // Set instance properties
      charWidth : charWidth,
      charHeight : charHeight, // Not currently used in the logic
    
    
      /**
       * Determines if the given character is a full-width Japanese character (Kanji, Hiragana, Katakana, or certain symbols).
       * @param {string} char - The character to check.
       * @returns {boolean} - True if it's a full-width Japanese character, false otherwise.
       */
      isJapaneseChar : function(char) {
          // Kanji Unicode range
          // Hiragana Unicode range
          // Katakana Unicode range
          // Specific full-width symbols （ー、～、－、＠）
          return ('\u4e00' <= char && char <= '\u9fff') || // CJK Unified Ideographs (Kanji)
                 ('\u3040' <= char && char <= '\u309f') || // Hiragana
                 ('\u30a0' <= char && char <= '\u30ff') || // Katakana
                 ('ー～－＠'.includes(char)); // Specific full-width symbols
      },
      /**
       * Calculates the display width of the text.
       * Full-width Japanese characters are calculated with `this.charWidth`, while other characters use `this.charWidth / 2`.
       * @param {string} text - The text for which to calculate the width.
       * @returns {number} - The calculated width of the text.
       */
      calcTextWidth : function(text) {
          let totalWidth = 0;
          for (const char of text) {
              if (this.isJapaneseChar(char)) {
                  totalWidth += this.charWidth;
              } else {
                  totalWidth += (this.charWidth / 2);
              }
          }
          return totalWidth;
      },
      /**
       * Splits the text into units of words or characters.
       * Splits by Japanese characters, full-width numbers, full-width alphanumeric characters,
       * half-width alphanumeric words, punctuation, and spaces.
       * @param {string} text - The text to split.
       * @returns {string[]} - An array of split words/characters.
       */
      splitText : function(text) {
          // Implements logic similar to Python's `re.findall` in JavaScript.
          // Uses Unicode property escapes and the 'u' flag for more accurate matching.
          //const pattern = /(\p{Script=Hiragana}|\p{Script=Katakana}|\p{Script=Han}|[ー～－＠、。；：！？（）「」]|\p{General_Category=Decimal_Number}|\p{General_Category=Lowercase_Letter}|\p{General_Category=Uppercase_Letter}|[a-zA-Z0-9]+|[(),.:;!?@%<>\-\/]|[ \s\t\n\r\f\v]+)/gu;
          const pattern = /([ぁ-んをァ-ン一-龥ーｰ～－＝、。；：！？（）「」]|[０-９]|[ａ-ｚＡ-Ｚ]|[a-zA-Z0-9]+|[\/\\(),.:;\=!?'#@%\^\$\~<>\-]|\s+)/g;
          
          const matches = text.match(pattern);
          // Add null check: return an empty array if no matches are found
          return matches ? matches.filter(x => x) : [];
      },
      /**
       * Wraps the text based on the specified maximum width.
       * @param {string} text - The text to wrap.
       * @param {number} maxWidth - The maximum width for a single line.
       * @returns {string[]} - An array of wrapped lines.
       */
      wrapText : function(text, maxWidth) {
          const words = this.splitText(text);
          const lines = [];
          let currentLine = [];
          let currentWidth = 0;
      
          for (const word of words) {
              const wordWidth = this.calcTextWidth(word);
      
              // If the word can be added to the current line
              if (currentWidth + wordWidth <= maxWidth) {
                  currentLine.push(word);
                  currentWidth += wordWidth;
              } else {
                  // If it's an English word (check if it consists only of half-width alphanumeric characters)
                  if (/^[a-zA-Z0-9]+$/.test(word)) {
                      // If the current line is not empty, finalize it and move to the next line
                      if (currentLine.length > 0) {
                          lines.push(currentLine.join(''));
                          currentLine = [];
                          currentWidth = 0;
                      }
      
                      // Split the word only if the word itself exceeds the maximum width
                      if (wordWidth > maxWidth) {
                          const chars = Array.from(word); // Convert string to array of characters (handles surrogate pairs)
                          let tempLine = [];
                          let tempWidth = 0;
      
                          for (const char of chars) {
                              const charWidth = this.calcTextWidth(char);
                              if (tempWidth + charWidth <= maxWidth) {
                                  tempLine.push(char);
                                  tempWidth += charWidth;
                              } else {
                                  if (tempLine.length > 0) { // Only add if the line is not empty
                                      lines.push(tempLine.join(''));
                                  }
                                  tempLine = [char];
                                  tempWidth = charWidth;
                              }
                          }
      
                          if (tempLine.length > 0) {
                              currentLine = tempLine;
                              currentWidth = tempWidth;
                          }
                      } else {
                          // If the word fits at the beginning of a new line
                          currentLine = [word];
                          currentWidth = wordWidth;
                      }
                  } else {
                      // If it's a Japanese character, punctuation, or other split word
                      if (currentLine.length > 0) {
                          lines.push(currentLine.join(''));
                      }
                      currentLine = [word];
                      currentWidth = wordWidth;
                  }
              }
          }
      
          // Add the last line
          if (currentLine.length > 0) {
              lines.push(currentLine.join(''));
          }
      
          return lines;
      }
    }
    return ret;
}
