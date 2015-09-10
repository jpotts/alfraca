alfraca
=======

Integrates the Alpaca forms engine with Alfresco.

This is a fork of the original demo project by Tribloom. It has been modified to work with the latest version of the Alfresco Maven SDK and to run within Alfresco 5.0.d Community Edition.

Building
--------

Checkout this project, then run `mvn package` from the alpaca-repo folder. Then do it again for the alpaca-share folder. This will produce two AMPs--one is for the "repo" tier and the other is for the "share" tier.

Deploying
---------

The repo tier AMP goes in $ALFRESCO_HOME/amps. The Share tier AMP goes in $ALFRESCO_HOME/amps_share. Copy the AMPs to the appropriate location, then run $ALFRESCO_HOME/bin/apply_amps.sh.

You should now be able to upload an empty JSON file and when you click "Edit with Alpaca" you will see a demo "Product" form.

Adding your own forms
---------------------

Your own forms should be kept in a separate project. These instructions tell you how to do that. They assume you are familiar with the Alfresco Maven SDK. There are several steps here. If you want to contribute to this project, reducing or completely eliminating the need for these steps is a high priority.

First, create a "Share AMP" project with the Maven SDK.

Within your new project, under src/main/amp/web create a new folder for your custom client-side JavaScript. Maybe name it after your organization, like "someco".

Within that, create a js folder, and within that a folder called "fields" and one called "schema". You could optionally create a third folder called "layouts" if you will be using Alpaca layout templates for your forms.

If it helps, open up the alpaca-share project and copy the demo ProductField.js and ProductSchema.js files into the appropriate folders that you just created.

Modify your field and schema files as needed to implement your forms. Refer to the Alpaca site for details.

Copy the AlpacaForms.js file from the alpaca-share project into src/main/amp/web/js/[YOUR FOLDER] where "YOUR FOLDER" is "someco" in my example above.

Edit AlpacaForms.js. Suppose, for example, you have one two forms. One is the demo Product form that came with this distribution. The other is a Purchase Order form. You want to use the demo Product form for all instances of cm:content but you want to use the Purchase Order form for instances of sc:purchaseOrder, for example.

Immediately after the csrf_token block, add this:

    var schema = Alpaca.Forms.Schema.Product;
    var options = Alpaca.Forms.Options.Product;
    var view = {};
    if (node.type == "{http://www.someco.com/model/content/1.0}purchaseOrder") {
      schema = Alpaca.Forms.Schema.SOW;
      options = Alpaca.Forms.Options.SOW;
      view = Alpaca.Forms.View.SOW;
    }

A few lines down, change these lines:

    $("#alpaca-form-field").alpaca({
      "data" : content,
      "schema" : Alpaca.Forms.Schema.Product,
      "options" : Alpaca.Forms.Options.Product,
      "postRender" : function(form) {

To this:

    $("#alpaca-form-field").alpaca({
      "data" : content,
      "schema" : schema,
      "options" : options,
      "view": view,
      "postRender" : function(form) {

Now when you edit JSON, Alpaca will use the appropriate form based on the type of node you are editing.

Last, you have to tell Share to include these new JavaScript files. To do that, copy alpaca-form.get.head.ftl from the alpaca-share project into your own package structure in your own project. For example, you might copy it to src/main/amp/config/alfresco/web-extension/site-webscripts/com/someco.

First, delete the reference to AlpacaForms.js. You'll use yours instead.

After the Alpaca CSS section, add references to your own JavaScript files, which would look something like:

    <script type="text/javascript" src="${page.url.context}/res/someco/js/AlpacaForms.js"></script>
    <script type="text/javascript" src="${page.url.context}/res/someco/js/fields/SOWField.js"></script>
    <script type="text/javascript" src="${page.url.context}/res/someco/js/schema/SOWSchema.js"></script>

Save and close the file.

Finally, tell Share to use your version of the Freemarker file you just edited instead of the one that ships with the alpaca-share AMP by creating a Share module extension. You can do that by adding a file called someco-alpaca-module-extension.xml to src/main/amp/config/alfresco/web-extension/site-data with the following content:

    <extension>
      <modules>
        <module>
          <id>Someco Alpaca Forms</id>
          <version>1.0</version>
          <auto-deploy>true</auto-deploy>  
          <customizations>
            <customization>
              <targetPackageRoot>org.alpacajs</targetPackageRoot>
              <sourcePackageRoot>com.someco</sourcePackageRoot>
            </customization>
          </customizations>
        </module>
      </modules>
    </extension>

Now build your Share AMP and deploy it alongside your other AMPs. When you edit JSON you should see your Alpaca form depending on the node type.

Pull requests welcome
---------------------

There is a *lot* of room for improvement here, particularly to reduce the amount of work one must do to add their own forms. For example, it would be really cool if the fields, schema, and layouts could simply be uploaded to the Alfresco data dictionary, as well as a type-to-form mapping, and then we we wouldn't have to fool with the tedium above. Pull requests welcome.
