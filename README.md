# Commitm: Commit Messages Done Quickly!
Commitm is a script to output a commit message randomly picked
from a list.

## Contributing
Want to add commit messages? You’re welcome.

Just fork, update one/some/all of these message files by running:
* Common, language-agnostic:
  ```
  commitm -add "New commit message"
  ```
* Language-specific, such as: 
  ```
  commitm -lang perl -add "New commit message"
  ```

Guidelines:
* No profanity.
* Keep it brief. Shorter than 65 characters is great.
* Feel free to add new file(s) for your language of choice, too.


### Descriptive Mode

```
commitm --descriptive
commitm --lang perl --descriptive
```

In this mode, a randomised description is output in addition to the
one liner. 

At this time, the `--lang` flag has no bearing on the description.

Description sources are not checked in. To locally retrieve and preprocess data used for 
descriptions:

```
# Download and preprocess description data files, from publicly available
# sources like Project Gutenberg (https://www.gutenberg.org/)
tools/get-files.sh
```

Only needs to be done once for any new data sources added &mdash; to contribute, 
fork and update `get-files.sh` to point to a new datasource, e.g., add the
line:

```
get_text "https://www.gutenberg.org/files/1342/1342-0.txt" pride-and-prejudice.txt
```

Guidelines:

* Description data files are never to be checked in.
* They must be in the public domain or be under a permissive license (for public   
  contribution purposes), easily downloadable through `curl`.
* At this time, preprocessing is only supported for UTF-8 encoded plain text 
  files, with assumptions on punctuation markers for sentences.
* Enhancements to the preprocessor are welcome, but they are to be treated as 
  offline processes, not incorporated into the simple online random selection
  mechanism of `commitm`.


### Meta Guidelines

I don’t get paid to do this, so, please be patient if I don’t
merge your pull request in a timely manner. Also, it’s up to me
whether I do it.


## Licence
© ade ishs. The use of this software is governed by the [MIT
licence](LICENCE.md).
