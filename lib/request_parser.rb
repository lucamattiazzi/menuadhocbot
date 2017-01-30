class RequestParser

  attr_accessor :params, :ingredients, :course

  def initialize(params)
    @params = params
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
    return @ingredients.join(",") + @course
  end
  def search_for_ingredients
    return @ingredients.join(",") + "ebbasta"
  end
  def search_for_course
    return "solo la " + @course
  end
  def suggest_best_or_random
    return "nothing, sry :("
  end

end
