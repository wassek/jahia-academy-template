<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="currentLang" value="${renderContext.mainResourceLocale.language}"/>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="${currentLang}" lang="${currentLang}" >
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
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
<c:set var="mainResourceNode" value="${renderContext.mainResource.node}"/>
<head>
    <meta charset="utf-8">
    <c:if test="${! renderContext.liveMode}">
        <meta name="robots" content="noindex">
    </c:if>
    <c:if test="${pageContext.request.serverName ne 'academy.jahia.com'}">
        <meta name="robots" content="noindex">
    </c:if>
    <c:set var="pageTitle"
           value="${mainResourceNode.displayableName}"/>
    <c:if test="${jcr:isNodeType(mainResourceNode, 'jacademix:alternateTitle')}">
        <c:set var="alternateTitle" value="${mainResourceNode.properties.alternateTitle.string}"/>
        <c:if test="${not empty alternateTitle}">
            <c:set var="pageTitle"
                   value="${alternateTitle}"/>
        </c:if>
    </c:if>
    <c:if test="${jcr:isNodeType(mainResourceNode, 'jnt:page')}">
        <c:if test="${mainResourceNode.properties['j:templateName'].string eq 'documentation'}">
            <%-- This is a doc -> try to get the product name --%>
            <c:set var="pageNodes"
                   value="${jcr:getMeAndParentsOfType(renderContext.mainResource.node, 'jacademix:isVersionPage')}"/>
            <%--
            we try to get the parent page with a jacademix:isVersionPage mixin. This will be the current version
            of the page.
            --%>
            <c:forEach var="pageNode" items="${pageNodes}" end="0">
                <c:set var="versionNode" value="${pageNode}"/>
                <c:set var="productNode" value="${versionNode.parent}"/>
                <c:set var="productInfo">${' '}|${' '}${productNode.displayableName}${' '}(${versionNode.displayableName})</c:set>
            </c:forEach>
        </c:if>
    </c:if>
    <title>${fn:escapeXml(pageTitle)}${fn:escapeXml(productInfo)}</title>
    <c:if test="${not empty mainResourceNode.properties['jcr:description'].string}">
        <c:set var="pageDescription"
               value="${fn:substring(mainResourceNode.properties['jcr:description'].string,0,160)}"/>
        <meta name="description" content="${fn:escapeXml(pageDescription)}"/>
        <meta property="og:description" content="${fn:escapeXml(pageDescription)}"/>
    </c:if>
    <meta property="og:type" content="article"/>
    <c:choose>
        <c:when test="${currentLang eq 'en'}">
            <meta property="og:locale" content="en_US"/>
        </c:when>
        <c:when test="${currentLang eq 'fr'}">
            <meta property="og:locale" content="fr_FR"/>
        </c:when>
        <c:when test="${currentLang eq 'de'}">
            <meta property="og:locale" content="de_DE"/>
        </c:when>
        <c:otherwise>
            <meta property="og:locale" content="${currentLang}"/>
        </c:otherwise>
    </c:choose>
    <meta property="og:title" content="${fn:escapeXml(pageTitle)}${fn:escapeXml(productInfo)}"/>
    <c:choose>
        <c:when test="${pageContext.request.serverPort == 80 || pageContext.request.serverPort == 443}">
            <c:set var="serverUrl" value="${pageContext.request.scheme}://${pageContext.request.serverName}"/>
        </c:when>
        <c:otherwise>
            <c:set var="serverUrl"
                   value="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}"/>
        </c:otherwise>
    </c:choose>
    <c:url var="currentPageUrl" value="${mainResourceNode.url}"/>
    <meta property="og:url" content="${serverUrl}${currentPageUrl}"/>
    <c:set var="imageUrl" value="${url.currentModule}/img/logo.png"/>
    <c:set var="imageWidth" value="250"/>
    <c:set var="imageHeight" value="120"/>
    <meta property="og:image" content="${serverUrl}${imageUrl}"/>
    <meta property="og:image:width" content="${imageWidth}"/>
    <meta property="og:image:height" content="${imageHeight}"/>

    <c:if test="${jcr:isNodeType(mainResourceNode, 'jnt:page')}">
        <c:if test="${mainResourceNode.properties['j:templateName'].string eq 'documentation'}">
            <c:url var="ampUrl" value="https://mercury.postlight.com/amp">
                <c:param name="url" value="${serverUrl}${currentPageUrl}"/>
            </c:url>

            <link rel="amphtml" href="${ampUrl}">
        </c:if>
    </c:if>


    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1"/>
    <%--link href='//fonts.googleapis.com/css?family=Lato&subset=latin,latin-ext' rel='stylesheet' type='text/css'--%>
    <link href="https://fonts.googleapis.com/css?family=Lato|Varela+Round" rel="stylesheet">


    <template:addResources type="css" resources="bootstrap.min.css"/>
    <template:addResources type="css" resources="bootstrapXl.css"/>
    <template:addResources type="css" resources="github.css"/>
    <template:addResources type="css" resources="clipboard.css"/>
    <template:addResources type="css" resources="font-awesome.min.css"/>
    <template:addResources type="css" resources="highlightjs-line-numbers.css"/>
    <template:addResources type="css" resources="ekko-lightbox.min.css"/>
    <template:addResources type="css" resources="academy.css"/>
    <c:if test="${renderContext.editMode}">
        <template:addResources type="css" resources="academy.edit.css"/>
    </c:if>

    <template:addResources type="javascript" resources="jquery.min.js"/>
    <template:addResources type="javascript" resources="jquery-ui.min.js"/>
    <template:addResources type="javascript" resources="bootstrap.min.js"/>
    <template:addResources type="javascript" resources="highlight.pack.js"/>
    <template:addResources type="javascript" resources="highlightjs-line-numbers.min.js"/>
    <template:addResources type="javascript" resources="clipboard.min.js"/>
    <template:addResources type="javascript" resources="academy/libraries/dynamicgrid.js"/>
    <template:addResources type="javascript" resources="ekko-lightbox.min.js"/>
    <template:addResources type="javascript" resources="headroom.min.js"/>
    <template:addResources type="javascript" resources="jQuery.headroom.js"/>
    <template:addResources type="javascript" resources="readingTime.js"/>
    <template:addResources type="javascript" resources="stacktable.js"/>
    <template:addResources type="javascript" resources="academy/academy.js"/>

    <template:addResources type="javascript" resources="i18n/form-factory-core-i18n_en.js,lib/_ff2Live.js,lib/jasny-bootstrap.fileinput.js,lib/_ff-rendering.min.js,lib/angular-i18n/angular-locale_en.js"/>
    

    <link rel="shortcut icon" href="${url.currentModule}/img/favicon/favicon.ico" type="image/x-icon">

    <link rel="apple-touch-icon" sizes="57x57" href="${url.currentModule}/img/favicon/apple-icon-57x57.png">
    <link rel="apple-touch-icon" sizes="60x60" href="${url.currentModule}/img/favicon/apple-icon-60x60.png">
    <link rel="apple-touch-icon" sizes="72x72" href="${url.currentModule}/img/favicon/apple-icon-72x72.png">
    <link rel="apple-touch-icon" sizes="76x76" href="${url.currentModule}/img/favicon/apple-icon-76x76.png">
    <link rel="apple-touch-icon" sizes="114x114" href="${url.currentModule}/img/favicon/apple-icon-114x114.png">
    <link rel="apple-touch-icon" sizes="120x120" href="${url.currentModule}/img/favicon/apple-icon-120x120.png">
    <link rel="apple-touch-icon" sizes="144x144" href="${url.currentModule}/img/favicon/apple-icon-144x144.png">
    <link rel="apple-touch-icon" sizes="152x152" href="${url.currentModule}/img/favicon/apple-icon-152x152.png">
    <link rel="apple-touch-icon" sizes="180x180" href="${url.currentModule}/img/favicon/apple-icon-180x180.png">
    <link rel="icon" type="image/png" sizes="192x192" href="${url.currentModule}/img/favicon/android-icon-192x192.png">
    <link rel="icon" type="image/png" sizes="32x32" href="${url.currentModule}/img/favicon/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="96x96" href="${url.currentModule}/img/favicon/favicon-96x96.png">
    <link rel="icon" type="image/png" sizes="16x16" href="${url.currentModule}/img/favicon/favicon-16x16.png">
    <meta name="msapplication-TileImage" content="${url.currentModule}/img/favicon/ms-icon-144x144.png"/>
</head>
<c:set var="homeCss"><c:if
        test="${mainResourceNode.path eq renderContext.site.home.path}">${' class="home"'}</c:if></c:set>
<body data-spy="scroll" data-target="#sidebar" data-offset="180" ${homeCss}><a id="top"></a>
<template:area path="pagecontent"/>
<template:area path="footer"/>
</body>
</html>
