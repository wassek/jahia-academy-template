<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>

<c:set var="parentPage" value="${currentNode.properties['parentPage'].node}"/>
<c:choose>
    <c:when test="${! empty parentPage}">
        <c:set var="depth" value="${currentNode.properties.depth.string}"/>
        <c:if test="${empty depth}">
            <c:set var="depth" value="1-level"/>
        </c:if>
        <ul class="book">
            <c:set var="pages" value="${jcr:getChildrenOfType(parentPage, 'jmix:navMenuItem')}"/>

            <c:forEach items="${pages}" var="page" varStatus="status">
                <template:addCacheDependency node="${page}"/>
                <li>
                    <c:set var="pageTitle" value="${page.displayableName}"/>
                    <c:choose>
                        <c:when test="${jcr:isNodeType(page, 'jnt:navMenuText')}">
                            <c:set var="pageUrl" value="#"/>
                            <%-- try to get the first subpage --%>
                            <c:if test="${depth ne '2-level-accordion'}">
                                <c:set var="subpages" value="${jcr:getChildrenOfType(page, 'jmix:navMenuItem')}"/>
                                <c:forEach items="${subpages}" var="subpage" varStatus="status">
                                    <c:if test="${status.first}">
                                        <c:choose>
                                            <c:when test="${jcr:isNodeType(subpage, 'jnt:navMenuText')}">
                                                <c:set var="pageUrl" value="#"/>
                                            </c:when>
                                            <c:when test="${jcr:isNodeType(subpage, 'jnt:externalLink')}">
                                                <c:url var="pageUrl" value="${subpage.properties['j:url'].string}"/>
                                            </c:when>
                                            <c:when test="${jcr:isNodeType(subpage, 'jnt:page')}">
                                                <c:url var="pageUrl" value="${subpage.url}"/>
                                            </c:when>
                                            <c:when test="${jcr:isNodeType(subpage, 'jnt:nodeLink')}">
                                                <c:url var="pageUrl" value="${subpage.properties['j:node'].node.url}"/>
                                            </c:when>
                                        </c:choose>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </c:when>
                        <c:when test="${jcr:isNodeType(page, 'jnt:externalLink')}">
                            <c:url var="pageUrl" value="${page.properties['j:url'].string}"/>
                        </c:when>
                        <c:when test="${jcr:isNodeType(page, 'jnt:page')}">
                            <c:url var="pageUrl" value="${page.url}"/>
                        </c:when>
                        <c:when test="${jcr:isNodeType(page, 'jnt:nodeLink')}">
                            <c:url var="pageUrl" value="${page.properties['j:node'].node.url}"/>
                            <c:if test="${empty pageTitle}">
                                <c:set var="pageTitle"
                                       value="${page.properties['j:node'].node.displayableName}"/>
                            </c:if>
                        </c:when>
                    </c:choose>

                    <c:set var="subpages" value="${jcr:getChildrenOfType(page, 'jmix:navMenuItem')}"/>
                    <c:set var="hasSubpages" value="${fn:length(subpages) > 0}"/>

                    <c:choose>
                        <c:when test="${depth eq '2-level-accordion' && hasSubpages}">
                            <a data-toggle="collapse" href="#ul${page.identifier}">${pageTitle}</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageUrl}">${pageTitle}</a>
                        </c:otherwise>
                    </c:choose>


                    <c:if test="${depth ne '1-level'}">
                        <c:if test="${hasSubpages}">
                            <div id="ul${page.identifier}" class="${depth eq '2-level-accordion' ? 'collapse' : ''}">
                                <ul>
                                    <c:if test="${depth eq '2-level-accordion' && ! jcr:isNodeType(page, 'jnt:navMenuText')}">
                                        <li><a href="${pageUrl}">${pageTitle}</a></li>
                                    </c:if>
                                    <c:forEach items="${subpages}" var="subpage" varStatus="status">
                                        <c:set var="subpageTitle" value="${subpage.displayableName}"/>
                                        <c:choose>
                                            <c:when test="${jcr:isNodeType(subpage, 'jnt:navMenuText')}">
                                                <c:set var="subpageUrl" value="#"/>
                                            </c:when>
                                            <c:when test="${jcr:isNodeType(subpage, 'jnt:externalLink')}">
                                                <c:url var="subpageUrl" value="${subpage.properties['j:url'].string}"/>
                                            </c:when>
                                            <c:when test="${jcr:isNodeType(subpage, 'jnt:page')}">
                                                <c:url var="subpageUrl" value="${subpage.url}"/>
                                            </c:when>
                                            <c:when test="${jcr:isNodeType(subpage, 'jnt:nodeLink')}">
                                                <c:url var="subpageUrl" value="${subpage.properties['j:node'].node.url}"/>
                                                <c:if test="${empty subpageTitle}">
                                                    <c:set var="subpageTitle"
                                                           value="${subpage.properties['j:node'].node.displayableName}"/>
                                                </c:if>
                                            </c:when>
                                        </c:choose>
                                        <li><a href="${subpageUrl}">${subpageTitle}</a></li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </c:if>
                    </c:if>

                </li>
            </c:forEach>
        </ul>
    </c:when>
    <c:otherwise>
        <c:if test="${renderContext.editMode}">
            Please select a parent page / label
        </c:if>
    </c:otherwise>
</c:choose>
