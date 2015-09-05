<#include "/org/alfresco/include/alfresco-template.ftl" />
<@templateHeader />

<@templateBody>
   <div id="alf-hd">
      <@region id="share-header" scope="global" />
   </div>
   <div id="bd">
      <div class="share-form">
         <@region id="edit-metadata-mgr" scope="template" />
         <@region id="edit-alpaca" scope="template" />
      </div>
   </div>

</@>

<@templateFooter>
   <div id="alf-ft">
      <@region id="footer" scope="global" />
   </div>
</@>
