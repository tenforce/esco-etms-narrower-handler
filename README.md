# ETMS narrower handler

This microservice will take care of narrowers after deletion or deprecation of a concept.

If a narrower was not published, it's publication status will be 'deleted'.
If a narrower was published, it's publication status will be 'ready for deprecation'.
