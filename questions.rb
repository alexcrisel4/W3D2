require 'byebug'
require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
      super('questions.db')
      self.type_translation = true
      self.results_as_hash = true
  end

end

class Question
  attr_accessor :id, :title, :body, :author_id

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT 
        *
      FROM
        questions
      WHERE 
        id = ?
      SQL
    # HOW SHOULD WE BE GETTING BACK MULTIPLE QUESTIONS FROM A SINGLE AUTHOR #  
     Question.new(data[0]) 
  end

  def self.find_by_author_id(author_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT 
        *
      FROM
        questions
      WHERE 
        author_id = ?
      SQL
    p data
    # HOW SHOULD WE BE GETTING BACK MULTIPLE QUESTIONS FROM A SINGLE AUTHOR #
    data.map { |datum| Question.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def author
    author_id = @author_id
    data = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        users 
      WHERE users.id = ?
    SQL
    p data
    data.map { |datum| User.new(datum) }
    # User.new(data[0])
  end

  def replies
    Reply.find_by_question_id(@id)
  end
end

class Reply
  def self.find_by_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL
    data.map { |datum| Reply.new(datum) }
  end

  def self.find_by_question_id(subject_question)
    data = QuestionsDatabase.instance.execute(<<-SQL, subject_question)
      SELECT
        *
      FROM
        replies
      WHERE
        subject_question = ?
    SQL
    #  data.map { |datum| Reply.new(datum) }
    Reply.new(data[0])
  end

  def initialize(options)
    @id = options['id'] 
    @subject_question = options['subject_question']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
    @body = options['body']
  end
end

class User
  def self.find_by_name(fname, lname)
    data = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT 
        *
      FROM
        users
      WHERE
        fname = ?
      AND
        lname = ?
    SQL
    User.new(data[0])
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end
end

# p Reply.find_by_question_id(1)
# p Reply.find_by_user_id(1)

# a = find_by_author_id(2)
# p a.author