tags = Array.new(20){ Tag.create name: Faker::Lorem.word }

200.times do
  Post.create( 
    title: Faker::Lorem.sentence.chomp('.'), 
    body: (Faker::Lorem.paragraphs rand(20)).join("\n\n"), 
    state: [ :draft, :finalized, :published, :tossed ].sample
  ).tags << tags.sample(Random.rand(5)+1)
end

markdown_text = <<MARKDOWN
An h1 header
============

Paragraphs are separated by a blank line.

2nd paragraph. *Italic*, **bold**, `monospace`. Itemized lists look like:

  * this one
  * that one
  * the other one

Note that --- not considering the asterisk --- the actual text content starts at 4-columns in.

> Block quotes are
> written like so.
>
> They can span multiple paragraphs,
> if you like.

Use 3 dashes for an em-dash. Use 2 dashes for ranges (ex. "it's all in chapters 12--14"). Three dots ... will be converted to an ellipsis.



An h2 header
------------

Here's a numbered list:

 1. first item
 2. second item
 3. third item

Note again how the actual text starts at 4 columns in (4 characters from the left side). Here's a code sample:

    # Let me re-iterate ...
    for i in 1 .. 10 { do-something(i) }


### An h3 header ###

Now a nested list:

 1. First, get these ingredients:

      * carrots
      * celery
      * lentils

 2. Boil some water.

 3. Dump everything in the pot and follow
    this algorithm:

        find wooden spoon
        uncover pot
        stir
        cover pot
        balance wooden spoon precariously on pot handle
        wait 10 minutes
        goto first step (or shut off burner when done)

    Do not bump wooden spoon or it will fall.

Notice again how text always lines up on 4-space indents (including that last line which continues item 3 above). Here's a link to [a website](http://foo.bar). Here's a link to a [local doc](local-doc.html).


Tables can look like this:

size  material      color
----  ------------  ------------
9     leather       brown
10    hemp canvas   natural
11    glass         transparent
MARKDOWN

Post.create( 
  title: 'Markdown Showcase', 
  body: markdown_text,
  state: 'published'
).tags << tags.sample(Random.rand(5)+1)

Post.all.each do |d| 
  if d.state == 'published'
    d.update_attributes(published_at: (DateTime.now - rand(600).hours))
  end
end

Editor.create(email: 'admin@admin.com', password: 'password', password_confirmation: 'password')
