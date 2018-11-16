@font-face {
    font-family: 'Futura-Std-Medium';
    src: url('../FuturaStdMediumOTF') format('opentype');
}
@font-face {
    font-family: 'Futura-Std-Book';
    src: url('../FuturaStdBookOTF') format('opentype');
}
@font-face {
    font-family: 'Futura-Std-Heavy';
    src: url('../FuturaStdHeavyOTF') format('opentype');
}
@font-face {
    font-family: 'Futura-Std-Bold';
    src: url('../FuturaStdBoldOTF') format('opentype');
}
.slds-table thead th {
    background-color:white;
}
th {
    background-color:white;
    
}
.label-hidden > label {
    display: none;
}
.card>.card-header {
    background-color: #F26925;
    color: #FFFFFF;
}
.card {
    margin-bottom: 20px;
}
.col {
    padding: 0px;
}
.report-43 {
    width: 43%;
    float:left;
}
.report-55 {
    width: 55%;
    float:right;
}
.report-100 {
    width: 100%;
}
footer .page-footer {
    font-size: 10.5px;
    font-family: 'Futura-Std-Book';
    padding-top:10px;
}
.assess-title {
    vertical-align: bottom;
    font-family: 'Futura-Std-Bold';
    font-size:15px;
    color:#333;
    text-size-adjust: 100%;
    display:table-cell;
    margin-top: auto;
    background-color:white;
    
}
.fixed-bottom {
    vertical-align:bottom;
}
.trainee-block {
    display:block;
}
.inline-block-class {
    display:inline-block;
}
.trainee-cell {
    display:table-cell;
    text-align: center;
}
.trainee-row {
    display:table-row;
}
.align-center {
    text-align: center;
}
/* all elements except for the page footer and its children */
*:not(.page-footer *) {    
    font-family: 'Futura-Std-Book';
    font-size: 14px;
}
@media screen and (max-width:1000px) {
    .radar-report, .line-chart {
        width:100%; /* The width is 100%, when the viewport is 800px or smaller */
    }
}