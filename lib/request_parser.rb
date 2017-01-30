class RequestParser

  attr_accessor :name, :ingredients, :course

  def initialize(name, params)
    @name = name
    @ingredients = params["ingrediente"]
    @course = params["portate"]
  end

  def parse
    case
    when @ingredients.present? && @course.present?
      search_for_course_and_ingredients
    when @ingredients.present?
      search_for_ingredients
    when @course.present?
      search_for_course
    else
      suggest_best_or_random
    end
  end

  def search_for_course_and_ingredients
    results = Wordpress::Post.search_ingredients(@ingredients)
    return results.inject("Ciao #{@name}!\nTi consiglio:\n") do |text, res|
      text += "#{res[:title]} : #{res[:url]}\n"
    end
  end

  def search_for_ingredients
    results = Wordpress::Post.search_ingredients(@ingredients)
    return results.inject("Ciao #{@name}!\nTi consiglio:\n") do |text, res|
      text += "#{res[:title]} : #{res[:url]}\n"
    end
  end

  def search_for_course
    return "Mi spiace devo ancora implementare qualcosa che funzioni :("
  end

  def suggest_best_or_random
    return "nothing, sry :("
  end


end
