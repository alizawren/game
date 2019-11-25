module WordWrap

  # given text and a maximum width, will break into an array of strings
  # such that the length of the strings is less than the maximum width
  def self.breakIntoLines(font, text, maxWidth)
    lines = []
    widths = []
    words = text.gsub(/\s+/m, " ").strip.split(" ")
    currText = ""
    for word in words
      newText = currText + word
      if font.text_width(newText) >= maxWidth
        lines.push(currText)
        widths.push(font.text_width(currText))
        currText = word + " "
      else
        currText = newText + " "
      end
    end
    lines.push(currText)
    widths.push(font.text_width(currText))
    return lines
  end

  # given text and a maximum width, count the number of lines the text will take up
  # and return this integer
  #   def self.numLines(text, maxWidth)
  #     i = 0
  #     j = 1
  #     numLines = 1
  #     while j < text.length
  #       currTextWidth = @font.text_width(text[i, j])
  #       if currTextWidth >= maxWidth
  #         i = j
  #         numLines += 1
  #       end
  #       j += 1
  #     end
  #     return numLines
  #   end
end
