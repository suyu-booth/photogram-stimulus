desc "Fill the database tables with some sample data"
task sample_data: :environment do
  starting = Time.now

  FollowRequest.destroy_all
  Comment.destroy_all
  Like.destroy_all
  Photo.destroy_all
  User.destroy_all

  people = Array.new(10) do
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name
    }
  end

  people << { first_name: "Alice", last_name: "Smith" }
  people << { first_name: "Bob", last_name: "Smith" }
  people << { first_name: "Carol", last_name: "Smith" }
  people << { first_name: "Dave", last_name: "Smith" }
  people << { first_name: "Eve", last_name: "Smith" }

  avatar_images = [
    "https://res.cloudinary.com/dzhwwlb9e/image/upload/v1743179672/10_tr3zoy.jpg",
    "https://res.cloudinary.com/dzhwwlb9e/image/upload/v1743179671/9_ozfgiu.jpg",
    "https://res.cloudinary.com/dzhwwlb9e/image/upload/v1743179671/8_pwngi1.jpg",
    "https://res.cloudinary.com/dzhwwlb9e/image/upload/v1743179671/7_pugev9.jpg",
    "https://res.cloudinary.com/dzhwwlb9e/image/upload/v1743179671/6_mobbi4.jpg",
    "https://res.cloudinary.com/dzhwwlb9e/image/upload/v1743179670/5_g6rxlz.jpg",
    "https://res.cloudinary.com/dzhwwlb9e/image/upload/v1743179670/4_qpszok.jpg",
    "https://res.cloudinary.com/dzhwwlb9e/image/upload/v1743179670/3_dymuoe.jpg",
    "https://res.cloudinary.com/dzhwwlb9e/image/upload/v1743179670/2_fb9rdr.jpg",
    "https://res.cloudinary.com/dzhwwlb9e/image/upload/v1743179670/1_njmhvj.jpg"
  ]

  photo_images = [
    "https://res.cloudinary.com/dzhwwlb9e/image/upload/v1743179692/10_op0tpz.jpg",
    "https://res.cloudinary.com/dzhwwlb9e/image/upload/v1743179691/9_iyhady.jpg",
    "https://res.cloudinary.com/dzhwwlb9e/image/upload/v1743179691/8_d5opde.jpg",
    "https://res.cloudinary.com/dzhwwlb9e/image/upload/v1743179691/7_rb5fmu.jpg",
    "https://res.cloudinary.com/dzhwwlb9e/image/upload/v1743179690/6_zvmuwq.jpg",
    "https://res.cloudinary.com/dzhwwlb9e/image/upload/v1743179690/5_ogrjwc.jpg",
    "https://res.cloudinary.com/dzhwwlb9e/image/upload/v1743179690/4_ow4t9b.jpg",
    "https://res.cloudinary.com/dzhwwlb9e/image/upload/v1743179689/3_fx6akk.jpg",
    "https://res.cloudinary.com/dzhwwlb9e/image/upload/v1743179689/2_kl1hpb.jpg",
    "https://res.cloudinary.com/dzhwwlb9e/image/upload/v1743179689/1_rnywum.jpg"
  ]

  people.each do |person|
    username = person.fetch(:first_name).downcase
    secret = false

    if [ "alice", "carol" ].include?(username) || User.where(private: true).count <= 6
      secret = true
    end

    user = User.new(
      email: "#{username}@example.com",
      password: "password",
      username: username.downcase,
      name: "#{person[:first_name]} #{person[:last_name]}",
      bio: Faker::Lorem.paragraph(
        sentence_count: 2,
        supplemental: true,
        random_sentences_to_add: 4
      ),
      website: Faker::Internet.url,
      private: secret
    )

    # Skip validations and callbacks to set the avatar_image directly
    user.save(validate: false)
    user.update_column(:avatar_image, avatar_images.sample)
  end

  users = User.all

  users.each do |first_user|
    users.each do |second_user|
      if rand < 0.75
        status = "accepted"
        if second_user.private?
          status = "pending"
        end
        first_user_follow_request = first_user.sent_follow_requests.create(
          recipient: second_user,
          status: status
        )
      end

      if rand < 0.75
        status = "accepted"
        if first_user.private?
          status = "pending"
        end
        second_user_follow_request = second_user.sent_follow_requests.create(
          recipient: first_user,
          status: status
        )
      end
    end
  end

  users.each do |user|
    rand(15).times do
      photo = user.own_photos.new(
        caption: Faker::Quote.jack_handey
      )

      # Skip validations and callbacks to set the image directly
      photo.save(validate: false)
      photo.update_column(:image, photo_images.sample)

      user.followers.each do |follower|
        if rand < 0.5
          photo.fans << follower
        end

        if rand < 0.25
          comment = photo.comments.create(
            body: Faker::Quote.jack_handey,
            author: follower
          )
        end
      end
    end
  end

  ending = Time.now
  p "It took #{(ending - starting).to_i} seconds to create sample data."
  p "There are now #{User.count} users."
  p "There are now #{FollowRequest.count} follow requests."
  p "There are now #{Photo.count} photos."
  p "There are now #{Like.count} likes."
  p "There are now #{Comment.count} comments."
end
