
module StringHelper

    def truncate_words(string, word_limit, end_string = ' ...')

      words = string.split(/\s/)
      if words.size >= word_limit 
        last_word = words.last
        words[0,(word_limit-1)].join(" ") + end_string + last_word
      else 
        string
      end


    end

end

