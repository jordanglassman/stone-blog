## Blog Demo

### Specs

* Editors should be able to to create/edit posts for a blog.
* Blog has the following attributes:
	* state (one of: draft, completed, published, tossed)
	* body (Markdown formatted text)
	* title
 	* published_at
	* slug
* Blog has many tags
* Editors should be able to see a list of all posts, then filter that list by state
* Allows users to see a single index page of all blog posts with the "published" status
* Allows users to see individual posts via a custom URL by means of the slug attribute