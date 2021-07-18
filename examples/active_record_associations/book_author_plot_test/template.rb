# frozen_string_literal: true

DEFAULT_FIELD_IDS = <<-'RUBY'
  <div class="field">
    <%= form.label :author_id %>
    <%= form.text_field :author_id %>
  </div>

  <div class="field">
    <%= form.label :plot_id %>
    <%= form.text_field :plot_id %>
  </div>
RUBY

SELECT_FIELD_IDS = <<-'RUBY'
  <div class="field">
    <%= form.label :author_id %>
    <%= collection_select(:book, :author_id, Author.all, :id, :name) %>
  </div>

  <div class="field">
    <%= form.label :plot_id %>
    <%= collection_select(:book, :plot_id, Plot.all, :id, :description) %>
  </div>
RUBY

def generate_scaffolds
  generate :scaffold, 'author name:string:uniq'
  generate :scaffold, 'plot description:text:uniq'
  generate :scaffold, 'book title:string:uniq author:references plot:references'
end

def update_references
  inject_into_class('app/models/book.rb', 'Book') { "  belongs_to :author\n  belongs_to :plot" }
  inject_into_class('app/models/plot.rb', 'Plot') { "  has_many :books\n" }
  inject_into_class('app/models/author.rb', 'Author') { "  has_many :books\n" }
end

def add_selects_for_references
  gsub_file('app/views/books/_form.html.erb', DEFAULT_FIELD_IDS, SELECT_FIELD_IDS)
end


generate_scaffolds
update_references
add_selects_for_references


