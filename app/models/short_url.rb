class ShortUrl < ApplicationRecord

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  before_create :short_code_generator
  after_create :call_update_title_job
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
      title: self.title,
    }
  end

  def short_code_generator
    code = ""
    # First we need to count how many records we have
    totRecords = ShortUrl.count(:short_code)
    numberChars = CHARACTERS.length()
    while totRecords >= 0
      # To know which letter we will use we can
      # use modulo operation 
      position = totRecords % numberChars
      code.concat(CHARACTERS[position])
      # We reduce the number of records by 
      # using the following formula
      # the division is like skipping all the
      # characters we have used in a specific position
      # and -1 is to choose the next character to
      # use so they do not repeat
      totRecords = totRecords/numberChars-1
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

  # call_update_title_job does what it says
  # and is called after create automatically
  def call_update_title_job
    UpdateTitleJob.perform_later(self)
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
