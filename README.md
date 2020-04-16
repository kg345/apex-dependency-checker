# apex-dependency-checker
<a href="https://githubsfdeploy.herokuapp.com?owner=kg345&repo=apex-dependency-checker&ref=master">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

Quick way to find all apex classes that are not being referenced by other non-test apex classes.

The assumption is that your test apex classes have the word "test" in their name.