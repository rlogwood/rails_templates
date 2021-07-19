# frozen_string_literal: true

# Test ActiveRecord self-join associations
# based on https://edgeguides.rubyonrails.org/association_basics.html#self-joins

COMMENT_MIGRATION_PATH = 'db/migrate/*_create_comments.rb'
COMMENT_MODEL_FILENAME = 'app/models/comment.rb'
BOOK_MODEL_FILENAME = 'app/models/book.rb'
USER_MODEL_FILENAME = 'app/models/user.rb'
PAGES_CONTROLLER_FILENAME = 'app/controllers/pages_controller.rb'

BOOK_VIEW_PARTIAL_FILENAME = 'app/views/pages/_book.html.erb'
COMMENT_VIEW_PARTIAL_FILENAME = 'app/views/pages/_comment.html.erb'
INDEX_VIEW_HTML_FILENAME = 'app/views/pages/index.html.erb'

APPLICATION_STYLESHEET_FILENAME = 'app/assets/stylesheets/application.css'

PAGES_CONTROLLER_INDEX = <<~'RUBY'

  render 'pages/index', locals: { books: Book.all }
RUBY

STYLESHEET = <<~CSS
  h1 {
    font-size: 3rem;
  }

  .book {
    padding-top: 10px;
  }

  .title {
    font-size: 2rem;
    font-weight: bold;
  }

  .author, .commenter {
    margin-left: 10px;
    font-size: .8rem;
    font-weight: lighter;
  }

  .comment {
    text-align: left;
    margin: 5px;
    padding-top: 5px;
    padding-left: 20px;
    font-size: 1.2rem;
  }
CSS

BOOK_VIEW_PARTIAL = <<~'ERB'
  <div class="book">
    <span class="title"><%= book.title %></span><span class="author">by <%= book.user.name %></span>
    <div>
      <% book.comments.threads.each do |thread| %>
        <%= render partial: 'comment', locals: { comment: thread } %>
      <% end %>
    </div>
  </div>
ERB

COMMENT_VIEW_PARTIAL = <<~'ERB'
  <div class="comment">
    <%= comment.body %> <span class="commenter">- <%= comment.user.name %></span>
    <% comment.replies.each do |reply| %>
      <%= render partial: 'comment', locals: {comment: reply}  %>
    <% end %>
  </div>
ERB

INDEX_VIEW_HTML = <<~'ERB'
  <h1>Books</h1>

  <% books.each do |book| %>
    <%= render partial: 'book', locals: { book: book } %>
  <% end %>
ERB

COMMENT_SELF_JOIN_ASSOCIATIONS = <<-RUBY
  has_many :replies, class_name: "Comment", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Comment", optional: true
  scope :threads, -> { where(parent_id: nil) }
RUBY

BOOK_ASSOCIATIONS = <<-RUBY
  has_many :comments
RUBY

USER_ASSOCIATIONS = <<-RUBY
  has_many :books
  has_many :comments, through: :books
RUBY

DB_SEEDS_CONTENT = <<~'SEEDS'
  User.create(name: 'Author Richards')
  User.create(name: 'Spock')
  User.create(name: 'Elmer')
  User.create(name: 'Watson')

  Book.create(title: 'The Best Experience', user_id: 1)
  Book.create(title: 'Yesterday is Gone Already', user_id: 1)

  Comment.create(body: 'very insightful, brilliant', user_id: 2, book_id: 1)
  Comment.create(body: 'i liked the plot, what was your favorite part?', parent_id: 1, user_id: 3, book_id: 1)
  Comment.create(body: 'the mountain top discovery', parent_id: 2, user_id: 2, book_id: 1)
  Comment.create(body: 'why did you explore that sub-plot', user_id: 4, book_id: 2)
  Comment.create(body: 'that will be in the sequel, can''t tell you now :)', parent_id: 4, user_id: 1, book_id: 2)
  Comment.create(body: 'how did you come up with the idea', user_id: 2, book_id: 2)
  Comment.create(body: 'I dream''t about it', user_id: 1, book_id: 2, parent_id: 6)
SEEDS

DB_SEEDS_FILENAME = 'db/seeds.rb'

COMMENT_MIGRATION_SELF_FK_REFERNCE = <<-RUBY

      t.references :parent, foreign_key: { to_table: :comments }
RUBY

def initialize_db
  create_file(DB_SEEDS_FILENAME, force: true)
  append_to_file(DB_SEEDS_FILENAME, DB_SEEDS_CONTENT)

  rails_command "db:drop"

  # NOTE: as of 7/18/21 db:prepare behaves differently on SqlLite3 and PostgresSQL
  # explicitly running commands to avoid a seeding problem on SqlLite3
  rails_command "db:create"
  rails_command "db:migrate"
  rails_command "db:seed"
end

def generate_scaffold
  generate :model, "user name"
  generate :model, "book title user:references"
  generate :model, "comment body:text book:references  user:references"
  generate :controller, "pages index"

  comment_migration_filename = Dir.glob(COMMENT_MIGRATION_PATH)[0]
  insert_into_file(comment_migration_filename, after: 't.text :body') { COMMENT_MIGRATION_SELF_FK_REFERNCE }
  inject_into_class(COMMENT_MODEL_FILENAME, 'Comment') { COMMENT_SELF_JOIN_ASSOCIATIONS }
  inject_into_class(BOOK_MODEL_FILENAME, 'Book') { BOOK_ASSOCIATIONS }
  inject_into_class(USER_MODEL_FILENAME, 'User') { USER_ASSOCIATIONS }
end

def setup_index_view
  create_file(BOOK_VIEW_PARTIAL_FILENAME, force: true)
  create_file(COMMENT_VIEW_PARTIAL_FILENAME, force: true)
  create_file(INDEX_VIEW_HTML_FILENAME, force: true)
  append_to_file(BOOK_VIEW_PARTIAL_FILENAME, BOOK_VIEW_PARTIAL)
  append_to_file(COMMENT_VIEW_PARTIAL_FILENAME, COMMENT_VIEW_PARTIAL)
  append_to_file(INDEX_VIEW_HTML_FILENAME, INDEX_VIEW_HTML)
  append_to_file(APPLICATION_STYLESHEET_FILENAME, STYLESHEET)
  insert_into_file(PAGES_CONTROLLER_FILENAME, after: 'def index') { PAGES_CONTROLLER_INDEX }
end

generate_scaffold
setup_index_view
initialize_db
route "root to: 'pages#index'"
