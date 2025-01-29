require 'sinatra'
require 'json'

# Define the Book class
class Book
  attr_accessor :title, :author, :year

  def initialize(title, author, year)
    @title = title
    @author = author
    @year = year
  end

  def to_json(*_args)
    { title: @title, author: @author, year: @year }.to_json
  end
end

# In-memory library to store books (this could be replaced by a database in a real app)
class Library
  def initialize
    @books = []
  end

  def all_books
    @books
  end

  def find_by_title(title)
    @books.find { |book| book.title.downcase == title.downcase }
  end

  def add_book(book)
    @books << book
  end

  def update_book(old_title, updated_book)
    book = find_by_title(old_title)
    if book
      book.title = updated_book.title
      book.author = updated_book.author
      book.year = updated_book.year
    end
  end

  def remove_book(title)
    book = find_by_title(title)
    @books.delete(book) if book
  end
end

# Initialize the Library
library = Library.new

# Default route to check if the API is running
get '/' do
  'Welcome to the Library API!'
end

# GET /books - Return all books
get '/books' do
  content_type :json
  library.all_books.to_json
end

# GET /books/:title - Get a specific book by title
get '/books/:title' do
  book = library.find_by_title(params[:title])
  if book
    content_type :json
    book.to_json
  else
    status 404
    { error: 'Book not found' }.to_json
  end
end

# POST /books - Add a new book
post '/books' do
  request_payload = JSON.parse(request.body.read)
  title = request_payload['title']
  author = request_payload['author']
  year = request_payload['year']

  # Add the book to the library
  new_book = Book.new(title, author, year)
  library.add_book(new_book)

  status 201
  content_type :json
  new_book.to_json
end

# PUT /books/:title - Update an existing book
put '/books/:title' do
  request_payload = JSON.parse(request.body.read)
  title = request_payload['title']
  author = request_payload['author']
  year = request_payload['year']

  updated_book = Book.new(title, author, year)

  if library.find_by_title(params[:title])
    library.update_book(params[:title], updated_book)
    content_type :json
    updated_book.to_json
  else
    status 404
    { error: 'Book not found' }.to_json
  end
end

# DELETE /books/:title - Remove a book by title
delete '/books/:title' do
  if library.find_by_title(params[:title])
    library.remove_book(params[:title])
    status 200
    { message: 'Book deleted successfully' }.to_json
  else
    status 404
    { error: 'Book not found' }.to_json
  end
end

# Start the Sinatra server
if __FILE__ == $0
  set :port, 4567
  #run!
end