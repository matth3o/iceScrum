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
--}%
<%@ page import="org.icescrum.core.domain.Sprint;" %>
<g:set var="inTeam" value="${request.teamMember || request.scrumMaster || request.productOwner}"/>
<g:set var="poOrSm" value="${request.scrumMaster || request.productOwner}"/>

<g:if test="${sprint?.id}">
%{--Add button--}%
<is:iconButton
        action="add"
        icon="create"
        class="close-sprint-${sprint.parentRelease.id}-${sprint.orderNumber}"
        rendered="${inTeam && sprint.state != Sprint.STATE_DONE}"
        id="${sprint.id}"
        controller="${controllerName}"
        shortcut="[key:'ctrl+n',scope:controllerName]"
        title="${message(code:'is.ui.sprintPlan.toolbar.alt.new')}"
        alt="${message(code:'is.ui.sprintPlan.toolbar.alt.new')}"
        update="window-content-${controllerName}">
    ${message(code: 'is.ui.sprintPlan.toolbar.new')}
</is:iconButton>

<is:separatorSmall class="close-sprint-${sprint.parentRelease.id}-${sprint.orderNumber}"
                   rendered="${inTeam && sprint.state != Sprint.STATE_DONE}"/>

%{--Delete button--}%
<is:iconButton
        icon="delete"
        class="close-sprint-${sprint.parentRelease.id}-${sprint.orderNumber}"
        rendered="${inTeam && sprint.state != Sprint.STATE_DONE}"
        onclick="jQuery.icescrum.selectableAction('task/delete',null,null,function(data){ jQuery.event.trigger('remove_task',[data]); jQuery.icescrum.renderNotice('${message(code:'is.task.deleted')}'); });"
        history='false'
        shortcut="[key:'del',scope:controllerName]"
        disabled="true"
        title="${message(code:'is.ui.sprintPlan.toolbar.alt.delete')}"
        alt="${message(code:'is.ui.sprintPlan.toolbar.alt.delete')}">
    ${message(code: 'is.ui.sprintPlan.toolbar.delete')}
</is:iconButton>

<is:separator class="close-sprint-${sprint.parentRelease.id}-${sprint.orderNumber}"
              rendered="${inTeam && sprint.state != Sprint.STATE_DONE}"/>

%{--View--}%
<is:panelButton alt="View" id="menu-display" arrow="true" icon="view">
    <ul>
        <li class="first">
            <a href="${createLink(action:'index',controller:controllerName,params:[product:params.product])}"
               data-default-view="postitsView"
               data-ajax-begin="$.icescrum.setDefaultView"
               data-ajax-update="#window-content-${controllerName}"
               data-ajax="true">${message(code:'is.view.postitsView')}</a>
        </li>
        <li class="last">
            <a href="${createLink(action:'index',controller:controllerName,params:[product:params.product, viewType:'tableView'])}"
               data-default-view="tableView"
               data-ajax-begin="$.icescrum.setDefaultView"
               data-ajax-update="#window-content-${controllerName}"
               data-ajax="true">${message(code:'is.view.tableView')}</a>
        </li>
    </ul>
</is:panelButton>

<is:separatorSmall/>

%{--Filter--}%
<is:panelButton alt="Filter"
                id="menu-filter-task"
                arrow="true"
                icon="filter"
                classDropmenu="${currentFilter == 'allTasks' ? '' : 'filter-active'}"
                text="${message(code:'is.ui.sprintPlan.toolbar.filter.'+currentFilter)}">
    <ul>
        <li class="first">
            <is:link
                    controller="${controllerName}"
                    action="changeFilterTasks"
                    params="[filter:'allTasks']"
                    history="false"
                    id="${params.id}"
                    onSuccess="jQuery.icescrum.updateFilterTask('${message(code:'is.ui.sprintPlan.toolbar.filter.allTasks')}', false);"
                    update="window-content-${controllerName}"
                    remote="true"
                    value="${message(code:'is.ui.sprintPlan.toolbar.filter.allTasks')}"/>
        </li>
        <li>
            <is:link controller="${controllerName}"
                     action="changeFilterTasks"
                     params="[filter:'myTasks']"
                     update="window-content-${controllerName}"
                     history="false"
                     onSuccess="jQuery.icescrum.updateFilterTask('${message(code:'is.ui.sprintPlan.toolbar.filter.myTasks')}', true);"
                     id="${params.id}"
                     remote="true"
                     value="${message(code:'is.ui.sprintPlan.toolbar.filter.myTasks')}"/>
        </li>
        <entry:point id="${controllerName}-${actionName}-filters" model="[sprint:sprint]"/>
        <g:if test="${sprint.state == Sprint.STATE_INPROGRESS}">
            <li>
        </g:if>
        <g:else>
            <li class="last">
        </g:else>
        <is:link controller="${controllerName}"
            action="changeFilterTasks"
            params="[filter:'freeTasks']"
            update="window-content-${controllerName}"
            onSuccess="jQuery.icescrum.updateFilterTask('${message(code:'is.ui.sprintPlan.toolbar.filter.freeTasks')}', true);"
            history="false"
            id="${params.id}"
            remote="true"
            value="${message(code:'is.ui.sprintPlan.toolbar.filter.freeTasks')}"/>
        </li>
    </ul>
</is:panelButton>

<is:separator/>

%{--Activate button--}%
<is:iconButton
        class="activate-sprint-${sprint.parentRelease.id}-${sprint.orderNumber} ${(sprint.activable) ?'':'hidden'}"
        rendered="${poOrSm}"
        action="activate"
        shortcut="[key:'ctrl+shift+a',scope:controllerName]"
        controller="releasePlan"
        history="false"
        id="${sprint.id}"
        onSuccess="if(data.dialog){ jQuery(document.body).append(data.dialog); }else{ jQuery.event.trigger('activate_sprint',data.sprint); jQuery.event.trigger('inProgress_story',[data.stories]); jQuery.icescrum.renderNotice('${g.message(code:'is.sprint.activated')}');}"
        before="if (!confirm('${g.message(code:'is.ui.sprintPlan.toolbar.activate.confirm')}')){ return false; };"
        alt="${message(code:'is.ui.sprintPlan.toolbar.alt.activate')}"
        title="${message(code:'is.ui.sprintPlan.toolbar.alt.activate')}">
    ${message(code: 'is.ui.sprintPlan.toolbar.activate')}
</is:iconButton>

<is:separator
        class="activate-sprint-${sprint.parentRelease.id}-${sprint.orderNumber} ${(sprint.activable) ?'':'hidden'}"
        rendered="${poOrSm && sprint.state == Sprint.STATE_WAIT}"/>

%{--Close button--}%
<is:iconButton
        class="close-sprint-${sprint.parentRelease.id}-${sprint.orderNumber} ${sprint.state == Sprint.STATE_INPROGRESS ?'':'hidden'}"
        rendered="${poOrSm}"
        action="close"
        shortcut="[key:'ctrl+shift+c',scope:controllerName]"
        controller="releasePlan"
        history="false"
        id="${sprint.id}"
        onSuccess="if(data.dialog){ jQuery(document.body).append(data.dialog); }else{ jQuery.event.trigger('close_sprint',data.sprint); jQuery.event.trigger('update_story',[data.stories]); jQuery.icescrum.renderNotice('${g.message(code:'is.sprint.closed')}');}"
        before="if (!confirm('${g.message(code:'is.ui.sprintPlan.toolbar.close.confirm')}')){ return false; };"
        alt="${message(code:'is.ui.sprintPlan.toolbar.alt.close')}"
        title="${message(code:'is.ui.sprintPlan.toolbar.alt.close')}">
    ${message(code: 'is.ui.sprintPlan.toolbar.close')}
</is:iconButton>

<is:separator
        class="close-sprint-${sprint.parentRelease.id}-${sprint.orderNumber} ${sprint.state == Sprint.STATE_INPROGRESS ?'':'hidden'}"
        rendered="${poOrSm}"/>

%{-- doneDefinition --}%
<is:iconButton
        alt="${message(code:'is.ui.sprintPlan.toolbar.alt.doneDefinition')}"
        title="${message(code:'is.ui.sprintPlan.toolbar.alt.doneDefinition')}"
        action="doneDefinition"
        shortcut="[key:'ctrl+shift+d',scope:controllerName]"
        id="${params.id}"
        controller="${controllerName}"
        update="window-content-${controllerName}">
    ${message(code: 'is.ui.sprintPlan.toolbar.doneDefinition')}
</is:iconButton>

<is:separatorSmall/>

%{-- retrospective --}%
<is:iconButton
        alt="${message(code:'is.ui.sprintPlan.toolbar.alt.retrospective')}"
        title="${message(code:'is.ui.sprintPlan.toolbar.alt.retrospective')}"
        action="retrospective"
        shortcut="[key:'ctrl+shift+r',scope:controllerName]"
        id="${params.id}"
        controller="${controllerName}"
        update="window-content-${controllerName}">
    ${message(code: 'is.ui.sprintPlan.toolbar.retrospective')}
</is:iconButton>

<is:separator/>

<is:panelButton alt="Charts" id="menu-chart" arrow="true" icon="graph" text="${message(code:'is.ui.toolbar.charts')}">
    <ul>
        <li class="first">
            <is:link
                    action="sprintBurndownHoursChart"
                    controller="${controllerName}"
                    id="${sprint.id}"
                    update="window-content-${controllerName}"
                    title="${message(code:'is.ui.sprintPlan.charts.sprintBurndownHoursChart')}"
                    remote="true"
                    value="${message(code:'is.ui.sprintPlan.charts.sprintBurndownHoursChart')}"/>
        </li>
        <li>
            <is:link
                    action="sprintBurnupTasksChart"
                    controller="${controllerName}"
                    id="${sprint.id}"
                    update="window-content-${controllerName}"
                    title="${message(code:'is.ui.sprintPlan.charts.sprintBurnupTasksChart')}"
                    remote="true"
                    value="${message(code:'is.ui.sprintPlan.charts.sprintBurnupTasksChart')}"/>
        </li>
        <li>
            <is:link
                    action="sprintBurnupStoriesChart"
                    controller="${controllerName}"
                    id="${sprint.id}"
                    update="window-content-${controllerName}"
                    title="${message(code:'is.ui.sprintPlan.charts.sprintBurnupStoriesChart')}"
                    remote="true"
                    value="${message(code:'is.ui.sprintPlan.charts.sprintBurnupStoriesChart')}"/>
        </li>
        <li class="last">
            <is:link
                    action="sprintBurnupPointsChart"
                    controller="${controllerName}"
                    id="${sprint.id}"
                    update="window-content-${controllerName}"
                    title="${message(code:'is.ui.sprintPlan.charts.sprintBurnupPointsChart')}"
                    remote="true"
                    value="${message(code:'is.ui.sprintPlan.charts.sprintBurnupPointsChart')}"/>
        </li>
    </ul>
</is:panelButton>

<is:separatorSmall/>

<is:reportPanel
        action="print"
        text="${message(code: 'is.ui.toolbar.print')}"
        formats="[
                  ['PDF', message(code:'is.report.format.pdf')],
                  ['RTF', message(code:'is.report.format.rtf')],
                  ['DOCX', message(code:'is.report.format.docx')],
                  ['ODT', message(code:'is.report.format.odt')]
                ]"
        params="id=${sprint.id}&locationHash='+encodeURIComponent(\$.icescrum.o.currentOpenedWindow.context.location.hash)+'"/>

<is:separatorSmall/>

<is:reportPanel
        action="printPostits"
        id="all"
        formats="[
                    ['PDF', message(code:'is.report.format.pdf')]
                ]"
        text="${message(code: 'is.ui.sprintPlan.toolbar.print.stories')}"
        params="id=${sprint.id}"/>

</g:if>
<entry:point id="${controllerName}-${actionName}" model="[sprint:sprint]"/>

<g:if test="${sprint?.id}">
%{--Search--}%
    <is:panelSearch id="search-ui">
        <is:autoCompleteSearch elementId="autoCmpTxt" controller="${controllerName}" action="index" id="${sprint.id}"
                               update="window-content-${controllerName}"/>
    </is:panelSearch>
</g:if>
