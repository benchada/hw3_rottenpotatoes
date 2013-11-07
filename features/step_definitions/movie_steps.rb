# Add a declarative step here for populating the DB with movies.
#Given the foll
Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page
Then /I should see all the movies/ do 
	Movie.find(:all).count.should == page.all('table tbody tr').count

end
Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  assert page.body.index(e1) < page.body.index(e2)
end

#Sorting alphabetically
Then /I should see movies sorted alphabetically/ do
   
   Movie.all(:order => :title).each_cons(2) do |a, b|

      step %Q{I should see "#{a.title}" before "#{b.title}"}
     
   end

end

# Sorting by release date

Then /I should see movies sorted by release date/ do

	Movie.all(:order=> :release_date)
end
# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb

 rating_list.split(",").each do |item|
    #%Q{When I #{uncheck}check "ratings[#{rating.strip.tr(%q{"'}, '')}]"}
    rating = "ratings_" + item.strip.tr(%q{"'}, '')
    if uncheck
      uncheck(rating)
    else
      check(rating)
    end
  end
end
