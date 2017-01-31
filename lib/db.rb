ActiveRecord::Base.configurations[:telegram] = {
  adapter: "mysql2",
  host: "localhost",
  database: ENV["TG_DB_NAME"],
  username: 'root',
  password: ENV["TG_DB_PASSWORD"] || false,
  pool: 20
}

ActiveRecord::Base.configurations[:wordpress] = {
  adapter: "mysql2",
  host: "localhost",
  database: ENV["WP_DB_NAME"],
  username: 'root',
  password: ENV["WP_DB_PASSWORD"] || false,
  pool: 20
}

ActiveRecord::Base.establish_connection ActiveRecord::Base.configurations[:telegram]

unless ActiveRecord::Base.connection.data_source_exists? "telegram_users"
  ActiveRecord::Base.connection.create_table(:telegram_users) do |t|
    t.column :telegram_id, :string
    t.column :first_name, :string
    t.column :last_name, :string
    t.column :user_name, :string
    t.column :requests_count, :integer, default: 0
    t.column :last_recipe_post_id, :integer
    t.column :last_recipe_post_duration, :integer
    t.column :last_recipe_post_request_date, :datetime
    t.column :last_recipe_post_feedback, :integer, default: 0
  end
end

unless ActiveRecord::Base.connection.data_source_exists? "telegram_messages"
  ActiveRecord::Base.connection.create_table(:telegram_messages) do |t|
    t.column :text, :string
    t.column :created_at, :datetime
    t.references :user
  end
end
