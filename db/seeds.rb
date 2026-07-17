puts "Seeding MyQuote database..."

QuoteCategory.delete_all
Quote.delete_all
Category.delete_all
Philosopher.delete_all
User.delete_all

# Reset SQLite autoincrement counters so IDs start from 1 again
%w[quote_categories quotes categories philosophers users].each do |table|
  ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='#{table}'")
end

# Users
# ----------------------------------------------------------------------
admin = User.create!(
  fname: "John", lname: "Jones",
  email: "admin@myquotes.com", password: "admin123",
  is_admin: true, status: "Active"
)

vincent = User.create!(
  fname: "Vincent", lname: "Brown",
  email: "vinceb@myemail.com", password: "vince123",
  is_admin: false, status: "Active"
)

alice = User.create!(
  fname: "Alice", lname: "Wright",
  email: "alice@myemail.com", password: "alice123",
  is_admin: false, status: "Active"
)
bob = User.create!(
  fname: "Bob", lname: "Carter",
  email: "bob@myemail.com", password: "bob123456",
  is_admin: false, status: "Active"
)

# Categories
# ----------------------------------------------------------------------
category_names = [
  "Ethics", "Metaphysics", "Epistemology", "Logic",
  "Political Philosophy", "Aesthetics", "Axiology",
  "Existentialism", "Stoicism"
]
categories = category_names.map { |n| Category.create!(catname: n) }

def cat(categories, name) = categories.find { |c| c.catname == name }


anonymous = Philosopher.create!(
  fname: "Anonymous",
  bio: "Used for quotes whose author/source is unknown."
)
socrates  = Philosopher.create!(
  fname: "Socrates", byear: "470 BC", dyear: "399 BC",
  bio: "Classical Greek philosopher credited as one of the founders of Western philosophy."
)
aristotle = Philosopher.create!(
  fname: "Aristotle", byear: "384 BC", dyear: "322 BC",
  bio: "Greek philosopher and polymath, student of Plato."
)
descartes = Philosopher.create!(
  fname: "René", lname: "Descartes", byear: "1596", dyear: "1650",
  bio: "French philosopher, mathematician and scientist; widely considered the father of modern philosophy."
)
nietzsche = Philosopher.create!(
  fname: "Friedrich", lname: "Nietzsche", byear: "1844", dyear: "1900",
  bio: "German philosopher whose work has had a profound influence on modern intellectual history."
)
sartre = Philosopher.create!(
  fname: "Jean-Paul", lname: "Sartre", byear: "1905", dyear: "1980",
  bio: "French existentialist philosopher, playwright, novelist and political activist."
)
seneca = Philosopher.create!(
  fname: "Seneca", byear: "4 BC", dyear: "AD 65",
  bio: "Roman Stoic philosopher, statesman, and dramatist."
)
aurelius = Philosopher.create!(
  fname: "Marcus", lname: "Aurelius", byear: "121", dyear: "180",
  bio: "Roman emperor and Stoic philosopher; author of 'Meditations'."
)
rawls = Philosopher.create!(
  fname: "John", lname: "Rawls", byear: "1921", dyear: "2002",
  bio: "American moral and political philosopher in the liberal tradition; author of 'A Theory of Justice'."
)

# Quotes 
# ----------------------------------------------------------------------
quotes_data = [
  { user: vincent, philosopher: socrates,
    qtext: "The unexamined life is not worth living.",
    qyear: "399 BC", qcom: "A foundational principle of self-reflection.",
    ispublic: true, cats: ["Ethics", "Epistemology", "Existentialism"] },

  { user: vincent, philosopher: socrates,
    qtext: "I know that I know nothing.",
    qyear: nil, qcom: "Kept private - a personal reminder to stay humble.",
    ispublic: false, cats: ["Epistemology", "Logic"] },

  { user: vincent, philosopher: aristotle,
    qtext: "Happiness depends upon ourselves.",
    qyear: nil, qcom: nil,
    ispublic: true, cats: ["Ethics", "Axiology"] },

  { user: alice, philosopher: aristotle,
    qtext: "Knowing yourself is the beginning of all wisdom.",
    qyear: nil, qcom: nil,
    ispublic: true, cats: ["Epistemology", "Ethics"] },

  { user: alice, philosopher: descartes,
    qtext: "I think, therefore I am.",
    qyear: "1637", qcom: "The cogito argument, from 'Discourse on the Method'.",
    ispublic: true, cats: ["Metaphysics", "Epistemology", "Logic"] },

  { user: alice, philosopher: nietzsche,
    qtext: "To live is to suffer, to survive is to find some meaning in the suffering.",
    qyear: nil, qcom: nil,
    ispublic: true, cats: ["Existentialism", "Ethics"] },

  { user: bob, philosopher: nietzsche,
    qtext: "He who has a why to live can bear almost any how.",
    qyear: "1889", qcom: "Personal motto - kept private.",
    ispublic: false, cats: ["Existentialism", "Axiology"] },

  { user: bob, philosopher: sartre,
    qtext: "Man is condemned to be free.",
    qyear: "1946", qcom: "Famous formulation of radical freedom.",
    ispublic: true, cats: ["Existentialism", "Ethics", "Metaphysics"] },

  { user: bob, philosopher: seneca,
    qtext: "We suffer more often in imagination than in reality.",
    qyear: nil, qcom: nil,
    ispublic: true, cats: ["Stoicism", "Ethics"] },

  { user: vincent, philosopher: seneca,
    qtext: "Luck is what happens when preparation meets opportunity.",
    qyear: nil, qcom: nil,
    ispublic: true, cats: ["Stoicism", "Axiology"] },

  { user: vincent, philosopher: aurelius,
    qtext: "You have power over your mind - not outside events.",
    qyear: "180", qcom: "A cornerstone of Stoic thought.",
    ispublic: true, cats: ["Stoicism", "Ethics"] },

  { user: vincent, philosopher: rawls,
    qtext: "Justice is the first virtue of social institutions.",
    qyear: "1971", qcom: "Opening line of 'A Theory of Justice'.",
    ispublic: true, cats: ["Political Philosophy", "Ethics"] }
]

quotes_data.each do |data|
  q = Quote.new(
    user:        data[:user],
    philosopher: data[:philosopher],
    qtext:       data[:qtext],
    qyear:       data[:qyear],
    qcom:        data[:qcom],
    ispublic:    data[:ispublic]
  )
  data[:cats].each do |cname|
    c = cat(categories, cname)
    q.quote_categories.build(category: c) if c
  end
  q.save!
end

puts "Done! Seeded #{User.count} users, #{Philosopher.count} philosophers (including hidden Anonymous), #{Category.count} categories and #{Quote.count} quotes."
puts "  Public quotes:  #{Quote.where(ispublic: true).count}"
puts "  Private quotes: #{Quote.where(ispublic: false).count}"
puts ""
puts "Required test accounts:"
puts "  Admin    -> admin@myquotes.com / admin123"
puts "  Standard -> vinceb@myemail.com / vince123"