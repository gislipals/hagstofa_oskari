<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html>
<head>
    <title>Oskari NLSI - ${viewName}</title>

    <!-- ############# css ################# -->
    <link
            rel="stylesheet"
            type="text/css"
            href="/Oskari${path}/icons.css"/>
    <link
        rel="stylesheet"
        type="text/css"
        href="/Oskari${path}/oskari.min.css"/>
    <style type="text/css">
        @media screen {
            body {
                margin: 0;
                padding: 0;
            }

            #mapdiv {
                width: 100%;
            }

            #maptools {
                background-color: #004a8f;
                height: 100%;
                position: absolute;
                top: 0;
                width: 153px;
                z-index: 2;
            }

            #contentMap {
                height: 100%;
                margin-left: 170px;
            }

            #login {
                margin-left: 5px;
            }

            #login input[type="text"], #login input[type="password"] {
                width: 90%;
                margin-bottom: 5px;
                background-image: url("/Oskari/${version}/resources/images/forms/input_shadow.png");
                background-repeat: no-repeat;
                padding-left: 5px;
                padding-right: 5px;
                border: 1px solid #B7B7B7;
                border-radius: 4px 4px 4px 4px;
                box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1) inset;
                color: #878787;
                font: 13px/100% Arial,sans-serif;
            }
            #login input[type="submit"] {
                width: 90%;
                margin-bottom: 5px;
                padding-left: 5px;
                padding-right: 5px;
                border: 1px solid #B7B7B7;
                border-radius: 4px 4px 4px 4px;
                box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1) inset;
                color: #878787;
                font: 13px/100% Arial,sans-serif;
            }
            #login p.error {
                font-weight: bold;
                color : red;
                margin-bottom: 10px;
            }

            #login a {
                color: #FFF;
                padding: 5px;
            }

            .oskari-tile-closed,.oskari-tile-minimized{
                border-top:1px solid #484846;
                border-bottom:1px solid #212121;
                background-color:#004a8f;
                background:-webkit-gradient(linear,left top,left bottom,from(#006b8f),to(#00008f));
                background:-moz-linear-gradient(top,#006b8f,#00008f);
                background:-ms-linear-gradient(top,#006b8f,#00008f);
                filter:progid:DXImageTransform.Microsoft.gradient(startColorstr="#006b8f",endColorstr="#00008f");
                background:linear-gradient(top,#006b8f,#00008f)
            }

            .oskari-tile-attached .oskari-tile-title,.oskari-tile-detached .oskari-tile-title{
            color:#004a8f;
            }

            .sidetool{
                position:absolute;
                left:100%;
                width:16px;
                height:100px;
                top:0;
                float:right;
                background-color:#004a8f;
            }

        }
    </style>
    <!-- ############# /css ################# -->
</head>
<body>

<nav id="maptools">
    <div id="lmilogo">
        <img src="Oskari/resources/images/LMI_logo_hlidar_serl_170x73.jpg" border="0">
    <div>
    <div id="loginbar">
    </div>
    <div id="menubar">
    </div>
    <div id="divider">
    </div>
    <div id="toolbar">
    </div>
    <div id="login">
        <c:choose>
            <c:when test="${!empty loginState}">
                <p class="error"><spring:message code="invalid_password_or_username" text="Invalid password or username!" /></p>
            </c:when>
        </c:choose>
        <c:choose>
            <%-- If logout url is present - so logout link --%>
            <c:when test="${!empty _logout_uri}">
                <form action="${pageContext.request.contextPath}${_logout_uri}" method="POST" id="logoutform">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <a href="${pageContext.request.contextPath}${_logout_uri}" onClick="jQuery('#logoutform').submit();return false;"><spring:message code="logout" text="Logout" /></a>
                </form>
                <%-- oskari-profile-link id is used by the personaldata bundle - do not modify --%>
                <a href="${pageContext.request.contextPath}${_registration_uri}" id="oskari-profile-link"><spring:message code="account" text="Account" /></a>
            </c:when>
            <%-- Otherwise show appropriate logins --%>
            <c:otherwise>
                <c:if test="${!empty _login_uri && !empty _login_field_user}">
                    <form action='${pageContext.request.contextPath}${_login_uri}' method="post" accept-charset="UTF-8">
                        <input size="16" id="username" name="${_login_field_user}" type="text" placeholder="<spring:message code="username" text="Username" />" autofocus
                               required>
                        <input size="16" id="password" name="${_login_field_pass}" type="password" placeholder="<spring:message code="password" text="Password" />" required>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <input type="submit" id="submit" value="<spring:message code="login" text="Log in" />">
                    </form>
                </c:if>
            </c:otherwise>
        </c:choose>
    </div>
</nav>
<div id="contentMap" class="oskariui container-fluid">
    <div id="menutoolbar" class="container-fluid"></div>
    <div class="row-fluid oskariui-mode-content" style="height: 100%; background-color:white;">
        <div class="oskariui-left"></div>
        <div class="span12 oskariui-center" style="height: 100%; margin: 0;">
            <div id="mapdiv"></div>
        </div>
        <div class="oskari-closed oskariui-right">
            <div id="mapdivB"></div>
        </div>
    </div>
</div>


<!-- ############# Javascript ################# -->

<!--  OSKARI -->

<script type="text/javascript">
    var ajaxUrl = '${ajaxUrl}';
    var controlParams = ${controlParams};
</script>
<%-- Pre-compiled application JS, empty unless created by build job --%>
<script type="text/javascript"
        src="/Oskari${path}/oskari.min.js">
</script>
<%--language files --%>
<script type="text/javascript"
        src="/Oskari${path}/oskari_lang_${language}.js">
</script>

<script type="text/javascript"
        src="/Oskari${path}/index.js">
</script>


<!-- ############# /Javascript ################# -->
</body>
</html>
