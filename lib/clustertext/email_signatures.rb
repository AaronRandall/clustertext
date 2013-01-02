module ClusterText
  module EmailSignatures
    
    require 'email_reply_parser'

    def self.remove(text)
      clean_text = text
      email = EmailReplyParser.read(text)         

      if email.fragments.size > 1
        ClusterText.log("Removing email signature: #{email.fragments.last}")

        clean_text = email.fragments.take(email.fragments.size - 1).join(" ")
        clean_text = clean_text.to_s.force_encoding("UTF-8")
      end

      clean_text
    end

  end
end
