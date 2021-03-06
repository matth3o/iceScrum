%{--
- Copyright (c) 2010 iceScrum Technologies.
-
- This file is part of iceScrum.
-
- iceScrum is free software: you can redistribute it and/or modify
- it under the terms of the GNU Affero General Public License as published by
- the Free Software Foundation, either version 3 of the License.
-
- iceScrum is distributed in the hope that it will be useful,
- but WITHOUT ANY WARRANTY; without even the implied warranty of
- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- GNU General Public License for more details.
-
- You should have received a copy of the GNU Affero General Public License
- along with iceScrum.  If not, see <http://www.gnu.org/licenses/>.
-
- Authors:
-
- Vincent Barrier (vbarrier@kagilum.com)
- Damien vitrac (damien@oocube.com)
- Manuarii Stein (manuarii.stein@icescrum.com)
- Stephane Maldini (stephane.maldini@icescrum.com)
--}%
<g:set var="productOwner" value="${request.productOwner}"/>
<g:set var="inProduct" value="${request.inProduct}"/>

%{--Add button--}%
<is:iconButton
        action="add"
        rendered="${!request.productArchived}"
        controller="${controllerName}"
        shortcut="[key:'ctrl+n',scope:controllerName]"
        title="${message(code:'is.ui.sandbox.toolbar.alt.new')}"
        alt="${message(code:'is.ui.sandbox.toolbar.alt.new')}"
        update="window-content-${controllerName}"
        icon="create">
    ${message(code: 'is.ui.sandbox.toolbar.new')}
</is:iconButton>


<is:separatorSmall rendered="${productOwner}"/>

%{--Accept button--}%
<is:iconButton
        rendered="${productOwner}"
        shortcut="[key:'ctrl+shift+a',scope:controllerName]"
        history="false"
        disabled="true"
        onClick="${is.remoteDialogFunction(
                          title:'is.dialog.acceptStory.title',
                          action:'openDialogAcceptAs',
                          controller:controllerName,
                          height:125,
                          width:360,
                          before:'if (jQuery.icescrum.postit.ids($(\'.postit.ui-selected,.table-row-focus\')) == false) return false;',
                          valid:[
                              action:'accept',
                              controller:'story',
                              params:'jQuery.icescrum.postit.ids($(\'.postit.ui-selected,.table-row-focus\'))',
                              onSuccess:'var type = jQuery(\'input[name=type]:checked\', \'#dialog form\').val(); $.event.trigger(\'accept_story\',data)',
                              button:'is.dialog.acceptAs.button'
                          ])
                  }"
        alt="${message(code:'is.ui.sandbox.toolbar.alt.accept')}"
        title="${message(code:'is.ui.sandbox.toolbar.alt.accept')}">
    ${message(code: 'is.ui.sandbox.toolbar.accept')}
</is:iconButton>

<is:separatorSmall rendered="${productOwner}"/>

<is:iconButton
        rendered="${productOwner}"
        shortcut="[key:'ctrl+shift+c',scope:controllerName]"
        onclick="jQuery.icescrum.selectableAction('story/copy',true,null,function(data){jQuery.event.trigger('add_story',[data]); jQuery.icescrum.renderNotice('${message(code:'is.story.selection.cloned')}');});"
        disabled="true"
        alt="${message(code:'is.ui.sandbox.toolbar.alt.clone')}"
        title="${message(code:'is.ui.sandbox.toolbar.alt.clone')}">
    ${message(code: 'is.ui.sandbox.toolbar.clone')}
</is:iconButton>

<is:separatorSmall rendered="${productOwner}"/>

%{--Delete button --}%
<is:iconButton
        icon="delete"
        rendered="${productOwner}"
        shortcut="[key:'del',scope:controllerName]"
        onclick="jQuery.icescrum.selectableAction('story/delete',null,null,function(data){jQuery.event.trigger('remove_story',[data]); jQuery.icescrum.renderNotice('${message(code:'is.story.deleted')}'); });"
        disabled="true"
        alt="${message(code:'is.ui.sandbox.toolbar.alt.delete')}"
        title="${message(code:'is.ui.sandbox.toolbar.alt.delete')}">
    ${message(code: 'is.ui.sandbox.toolbar.delete')}
</is:iconButton>

<is:separator rendered="${!request.productArchived}"/>

%{--View--}%
<is:panelButton alt="View" id="menu-display" arrow="true" icon="view">
    <ul>
        <li class="first">
            <a href="${createLink(action:'list',controller:controllerName,params:[product:params.product])}"
               data-default-view="postitsView"
               data-ajax-begin="$.icescrum.setDefaultView"
               data-ajax-update="#window-content-${controllerName}"
               data-ajax="true">${message(code:'is.view.postitsView')}</a>
        </li>
        <li class="last">
            <a href="${createLink(action:'list',controller:controllerName,params:[product:params.product, viewType:'tableView'])}"
               data-default-view="tableView"
               data-ajax-begin="$.icescrum.setDefaultView"
               data-ajax-update="#window-content-${controllerName}"
               data-ajax="true">${message(code:'is.view.tableView')}</a>
        </li>
    </ul>
</is:panelButton>

<is:separator/>
<is:reportPanel
        action="print"
        text="${message(code: 'is.ui.toolbar.print')}"
        formats="[
                  ['PDF', message(code:'is.report.format.pdf')],
                  ['RTF', message(code:'is.report.format.rtf')],
                  ['DOCX', message(code:'is.report.format.docx')],
                  ['ODT', message(code:'is.report.format.odt')]
                ]"/>
<entry:point id="${controllerName}-${actionName}"/>
%{--Textfield for the auto completion search--}%
<is:panelSearch id="search-ui">
    <is:autoCompleteSearch elementId="autoCmpTxt" controller="${controllerName}" action="list" update="window-content-${controllerName}"/>
</is:panelSearch>
