class ShortUrl < ApplicationRecord

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  before_create :short_code_generator
  validate :validate_full_url

  # public_attributes was created because
  # in short_urls_controller_spec.rb it is called
  # to check wheter it matches the criteria but
  # I can't get it to do the match 
  def public_attributes
    {
      id: self.id,
      short_code: self.short_code,
      full_url: self.full_url,
      click_count: self.click_count,
    }
  end

  def short_code_generator
    code = ""
    # First we need to count how many records we have
    totRecords = ShortUrl.count(:short_code)
    # Based on the previous value we will know how many
    # letters we will need for the shortened url
    numberChars = CHARACTERS.length()
    numberLetters = totRecords / numberChars
    while numberLetters >= 0
      # To know which letter we will use we can
      # use modulo operation 
      position = totRecords % numberChars
      code.concat(CHARACTERS[position])
      totRecords = totRecords-position
      numberLetters = numberLetters - 1
    end
    self.short_code = code
  end

  def update_title!
  end

  # increase_count is used when the show is called
  # in the controller so it increases visit_count
  # by 1 and returns the url to be redirected
  def increase_count
    self.increment!(:click_count)
		self.full_url
  end

  private

  # I use the regular expression from 
  # https://www.freecodecamp.org/news/check-if-a-javascript-string-is-a-url/
  # to validate the url but I think it would
  # be better to use a library
  # that handles this kind of thing
  def validate_full_url
    if full_url.present?
      if  not full_url.match(/(?:https?):\/\/(\w+:?\w*)?(\S+)(:\d+)?(\/|\/([\w#!:.?+=&%!\-\/]))?/)
        errors.add(:full_url, "Full url is not a valid url")
      end
    else 
      errors.add(:full_url, "can't be blank")
    end
  end

end
