<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%@ page import="java.util.*" %>
<%@ page import="com.tap.model.Order" %>
<%@ page import="com.tap.model.User" %>
<%!
    private String safe(Object value) {
        if (value == null) return "";
        return value.toString().replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
    private String onlyDate(Object value) {
        if (value == null) return "";
        String s = value.toString();
        return s.length() >= 10 ? s.substring(0, 10) : s;
    }
%>
<%
    User admin = (User) session.getAttribute("admin");
    if (admin == null) admin = (User) session.getAttribute("user");
    if (admin == null || admin.getRole() == null || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String cp = request.getContextPath();
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    if (orders == null) orders = (List<Order>) request.getAttribute("allOrders");
    if (orders == null) orders = Collections.emptyList();
    Map<Integer, String> customerNames = (Map<Integer, String>) request.getAttribute("customerNames");
    Map<Integer, String> restaurantNames = (Map<Integer, String>) request.getAttribute("restaurantNames");
    Map<Integer, String> restaurantOptions = new TreeMap<Integer, String>();
    if (restaurantNames != null) restaurantOptions.putAll(restaurantNames);
    for (Order order : orders) {
        int id = order.getRestaurantId();
        if (!restaurantOptions.containsKey(id)) restaurantOptions.put(id, "Restaurant #" + id);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Manage Orders | Foodcorner</title>
<style>
*{box-sizing:border-box}body{margin:0;font-family:Arial,Helvetica,sans-serif;background:#fff8f2;color:#232323}a{text-decoration:none}
.navbar{background:#191919;padding:18px 6%;display:flex;align-items:center;justify-content:space-between;gap:16px}.brand{font-size:26px;font-weight:800;color:#ff6b00}.brand span{color:white}.nav-links{display:flex;gap:20px;flex-wrap:wrap}.nav-links a{color:#eee;font-size:14px}.nav-links a:hover{color:#ff6b00}
.container{max-width:1260px;width:92%;margin:32px auto 50px}.page-heading{margin-bottom:24px}.page-heading h1{margin:0 0 9px;font-size:30px}.page-heading p{margin:0;color:#747474;font-size:14px;line-height:1.6}
.filters,.view-panel{background:white;border:1px solid #e9e9e9;border-radius:13px;padding:22px}.filters h2{margin:0 0 18px;font-size:17px}.filter-grid{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:15px}.field label{display:block;font-size:13px;font-weight:700;margin-bottom:8px}.field input,.field select{width:100%;min-width:0;border:1px solid #ddd;border-radius:8px;padding:12px;font-size:14px;background:white;color:#292929}.field input:focus,.field select:focus{outline:2px solid #ffd6b8;border-color:#ff6b00}.filter-actions{display:flex;gap:10px;margin-top:17px}.btn{border:0;border-radius:8px;padding:11px 17px;font-weight:700;cursor:pointer;font-size:13px}.btn-primary{background:#ff6b00;color:white}.btn-secondary{background:#ededed;color:#333}
.toolbar{display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:14px;margin:26px 0 13px}.toolbar h2{font-size:20px;margin:0}.view-buttons,.chart-buttons{display:flex;gap:8px;flex-wrap:wrap}.view-button,.chart-button{border:1px solid #ddd;background:white;color:#333;padding:11px 15px;border-radius:8px;font-weight:700;cursor:pointer;font-size:13px}.view-button.active{background:#ff6b00;color:white;border-color:#ff6b00}.chart-button.active{background:#fff0e5;border-color:#ff6b00;color:#e85d00}.summary{color:#6c6c6c;font-size:13px;margin:0 0 15px}.hidden{display:none!important}
.table-scroll{overflow-x:auto}.orders-table{width:100%;min-width:760px;border-collapse:collapse;text-align:left}.orders-table th{background:#fff3e9;padding:15px 12px;font-size:12px}.orders-table td{border-bottom:1px solid #eee;padding:15px 12px;font-size:13px}.orders-table tbody tr:hover{background:#fffaf6}.order-id{color:#e85d00;font-weight:700}.status{display:inline-block;background:#f0f0f0;border-radius:20px;padding:6px 10px;font-size:11px;font-weight:700}
.cards{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:16px}.order-card{border:1px solid #eee;border-radius:10px;padding:20px;min-width:0}.order-card h3{color:#e85d00;font-size:17px;margin:0 0 6px}.order-card .date{font-size:12px;color:#777;margin:0 0 16px}.detail{display:flex;justify-content:space-between;gap:12px;margin:12px 0;font-size:13px}.detail span{color:#777}.detail strong{text-align:right;overflow-wrap:anywhere}.card-footer{display:flex;justify-content:space-between;align-items:center;border-top:1px solid #eee;margin-top:18px;padding-top:15px;gap:10px}
.graph-head{display:flex;align-items:center;justify-content:space-between;gap:15px;flex-wrap:wrap}.graph-head h3{margin:0 0 7px;font-size:18px}.graph-head p{margin:0;color:#777;font-size:13px;line-height:1.5}.graph-controls{display:flex;align-items:center;gap:10px;flex-wrap:wrap}.graph-controls select{padding:10px;border:1px solid #ddd;border-radius:7px;background:white}.chart-scroll{width:100%;overflow-x:auto;margin-top:16px}#ordersChart{width:100%;min-width:580px;height:auto;display:block}.legend{margin-top:10px;font-size:12px;color:#666}.legend-dot{display:inline-block;width:10px;height:10px;border-radius:50%;background:#ff6b00;margin-right:7px}.empty{text-align:center;padding:45px 12px;color:#777;font-size:14px}.empty strong{display:block;color:#222;font-size:17px;margin-bottom:7px}.footer{background:#191919;color:#bbb;text-align:center;padding:21px;font-size:13px}.footer b{color:#ff6b00}
@media(max-width:950px){.filter-grid{grid-template-columns:repeat(2,minmax(0,1fr))}.cards{grid-template-columns:repeat(2,minmax(0,1fr))}}@media(max-width:600px){.container{width:94%}.navbar{padding:16px 4%}.brand{font-size:22px}.nav-links{gap:10px}.nav-links a{font-size:12px}.filter-grid,.cards{grid-template-columns:1fr}.filters,.view-panel{padding:16px}.toolbar{align-items:flex-start;flex-direction:column}.view-buttons{width:100%}.view-button{flex:1;padding:10px 7px}.page-heading h1{font-size:25px}}
</style>
</head>
<body>
<nav class="navbar"><a class="brand" href="<%= cp %>/adminDashboard.jsp">Food<span>corner</span></a><div class="nav-links"><a href="<%= cp %>/adminDashboard.jsp">Dashboard</a><a href="<%= cp %>/adminRestaurants">Restaurants</a><a href="<%= cp %>/logout">Logout</a></div></nav>
<main class="container">
<header class="page-heading"><h1>Manage Orders</h1><p>Switch between orders, cards and business-style daily or monthly charts.</p></header>
<section class="filters"><h2>Filter Orders</h2><div class="filter-grid">
<div class="field"><label for="fromDate">From Date</label><input id="fromDate" type="date"></div>
<div class="field"><label for="toDate">To Date</label><input id="toDate" type="date"></div>
<div class="field"><label for="restaurantFilter">Restaurant</label><select id="restaurantFilter"><option value="all">All Restaurants</option>
<% for (Map.Entry<Integer, String> item : restaurantOptions.entrySet()) { %>
<option value="<%= item.getKey() %>"><%= safe(item.getValue()) %></option>
<% } %>
</select></div>
<div class="field"><label for="searchFilter">Search</label><input id="searchFilter" type="search" placeholder="Order ID, customer, restaurant..."></div>
</div><div class="filter-actions"><button class="btn btn-primary" id="applyFilters" type="button">Apply Filters</button><button class="btn btn-secondary" id="clearFilters" type="button">Clear Filters</button></div></section>
<div class="toolbar"><h2>Order Overview</h2><div class="view-buttons"><button class="view-button active" type="button" data-view="list">List View</button><button class="view-button" type="button" data-view="cards">Card View</button><button class="view-button" type="button" data-view="graph">Graph View</button></div></div>
<p class="summary" id="resultSummary">Preparing order data...</p>
<section class="view-panel" id="listPanel"><div class="table-scroll"><table class="orders-table"><thead><tr><th>Order ID</th><th>Customer</th><th>Restaurant</th><th>Date</th><th>Payment</th><th>Total</th><th>Status</th></tr></thead><tbody id="ordersTableBody"></tbody></table></div><div class="empty hidden" id="listEmpty"><strong>No orders found</strong>Try another date or restaurant.</div></section>
<section class="view-panel hidden" id="cardsPanel"><div class="cards" id="ordersCards"></div><div class="empty hidden" id="cardsEmpty"><strong>No orders found</strong>Try another date or restaurant.</div></section>
<section class="view-panel hidden" id="graphPanel"><div class="graph-head"><div><h3 id="chartTitle">Daily Orders — Line Graph</h3><p>X-axis: date &nbsp;|&nbsp; Y-axis: number of orders</p></div><div class="graph-controls"><select id="groupBy" aria-label="Group orders by"><option value="day">By Day</option><option value="month">By Month</option></select><div class="chart-buttons"><button type="button" class="chart-button active" data-chart="line">Line Graph</button><button type="button" class="chart-button" data-chart="bar">Bar Graph</button></div></div></div><div class="chart-scroll" id="chartContainer"><svg id="ordersChart" viewBox="0 0 960 440" role="img" aria-label="Order counts by date"></svg></div><div class="legend" id="chartLegend"><span class="legend-dot"></span>Number of orders</div><div class="empty hidden" id="graphEmpty"><strong>No graph data available</strong>No dated orders match the filters.</div></section>
</main>
<footer class="footer">&copy; 2026 <b>Foodcorner</b>. All rights reserved.</footer>
<div id="orderSource" class="hidden" aria-hidden="true">
<% for (Order order : orders) {
    Object c = customerNames == null ? null : customerNames.get(order.getUserId());
    Object r = restaurantNames == null ? null : restaurantNames.get(order.getRestaurantId());
    String customer = c == null ? "Customer #" + order.getUserId() : c.toString();
    String restaurant = r == null ? "Restaurant #" + order.getRestaurantId() : r.toString();
%>
<div class="source-order" data-id="<%= safe(order.getOrderId()) %>" data-date="<%= safe(onlyDate(order.getOrderDate())) %>" data-restaurant-id="<%= safe(order.getRestaurantId()) %>" data-customer="<%= safe(customer) %>" data-restaurant="<%= safe(restaurant) %>" data-payment="<%= safe(order.getPaymentMode()) %>" data-total="<%= safe(order.getTotalAmount()) %>" data-status="<%= safe(order.getStatus()) %>"></div>
<% } %>
</div>
<script>
(function () {
    "use strict";
    const orders = Array.from(document.querySelectorAll(".source-order"), el => ({
        id: el.dataset.id || "", date: el.dataset.date || "", restaurantId: el.dataset.restaurantId || "",
        customer: el.dataset.customer || "Unknown", restaurant: el.dataset.restaurant || "Unknown",
        payment: el.dataset.payment || "N/A", total: Number(el.dataset.total) || 0, status: el.dataset.status || "Unknown"
    }));
    const byId = id => document.getElementById(id);
    const money = value => new Intl.NumberFormat("en-IN", {style:"currency",currency:"INR"}).format(value);
    const niceDate = s => /^\d{4}-\d{2}-\d{2}$/.test(s) ? s.slice(8,10)+"-"+s.slice(5,7)+"-"+s.slice(0,4) : (s || "Not available");
    let filtered = orders.slice(), activeView = "list", chartType = "line";
    function cell(row, value, className) {
        const td = document.createElement("td");
        td.textContent = value;
        if (className) td.className = className;
        row.appendChild(td);
    }
    function renderList() {
        const body = byId("ordersTableBody");
        body.replaceChildren();
        filtered.forEach(o => {
            const tr = document.createElement("tr");
            cell(tr, "#" + o.id, "order-id"); cell(tr, o.customer); cell(tr, o.restaurant);
            cell(tr, niceDate(o.date)); cell(tr, o.payment); cell(tr, money(o.total)); cell(tr, o.status);
            body.appendChild(tr);
        });
        byId("listEmpty").classList.toggle("hidden", filtered.length !== 0);
    }
    function detail(parent, label, value) {
        const line = document.createElement("div"); line.className = "detail";
        const a = document.createElement("span"); a.textContent = label;
        const b = document.createElement("strong"); b.textContent = value;
        line.append(a,b); parent.appendChild(line);
    }
    function renderCards() {
        const box = byId("ordersCards"); box.replaceChildren();
        filtered.forEach(o => {
            const card = document.createElement("article"); card.className = "order-card";
            const title = document.createElement("h3"); title.textContent = "Order #" + o.id;
            const date = document.createElement("p"); date.className = "date"; date.textContent = niceDate(o.date);
            card.append(title,date);
            detail(card,"Customer",o.customer); detail(card,"Restaurant",o.restaurant);
            detail(card,"Payment",o.payment); detail(card,"Status",o.status);
            const foot = document.createElement("div"); foot.className = "card-footer";
            const label = document.createElement("span"); label.textContent = "Total Amount";
            const amount = document.createElement("strong"); amount.textContent = money(o.total);
            foot.append(label,amount); card.appendChild(foot); box.appendChild(card);
        });
        byId("cardsEmpty").classList.toggle("hidden", filtered.length !== 0);
    }
    function series() {
        const monthly = byId("groupBy").value === "month";
        const counts = new Map();
        filtered.forEach(o => {
            if (!/^\d{4}-\d{2}-\d{2}$/.test(o.date)) return;
            const key = monthly ? o.date.slice(0,7) : o.date;
            counts.set(key, (counts.get(key) || 0) + 1);
        });
        const keys = Array.from(counts.keys()).sort();
        if (!monthly && keys.length > 0) {
            const start = byId("fromDate").value || keys[0];
            const end = byId("toDate").value || keys[keys.length - 1];
            const a = Date.parse(start + "T00:00:00Z"), b = Date.parse(end + "T00:00:00Z");
            if (Number.isFinite(a) && Number.isFinite(b) && b >= a && (b-a)/86400000 <= 365) {
                const all = [];
                for (let t=a;t<=b;t+=86400000) {
                    const k = new Date(t).toISOString().slice(0,10);
                    all.push({date:k,count:counts.get(k)||0});
                }
                return all;
            }
        }
        return keys.map(k => ({date:k,count:counts.get(k)}));
    }
    function svgElement(name, attributes, text) {
        const el = document.createElementNS("http://www.w3.org/2000/svg",name);
        Object.entries(attributes || {}).forEach(([k,v]) => el.setAttribute(k,String(v)));
        if (text !== undefined) el.textContent = text;
        return el;
    }
    function drawChart() {
        const svg = byId("ordersChart"), data = series(); svg.replaceChildren();
        const empty = data.length === 0;
        byId("graphEmpty").classList.toggle("hidden",!empty);
        byId("chartContainer").classList.toggle("hidden",empty);
        byId("chartLegend").classList.toggle("hidden",empty);
        const monthly = byId("groupBy").value === "month";
        byId("chartTitle").textContent = (monthly ? "Monthly" : "Daily") + " Orders — " + (chartType === "line" ? "Line Graph" : "Bar Graph");
        if (empty) return;
        const W=960,H=440,L=65,R=28,T=30,B=85,PW=W-L-R,PH=H-T-B;
        const maxCount=Math.max(1,...data.map(d=>d.count));
        const step=Math.max(1,Math.ceil(maxCount/4)), ymax=step*4;
        const x=i=>chartType === "bar" ? L+PW*(i+.5)/data.length : (data.length===1 ? L+PW/2 : L+PW*i/(data.length-1));
        const y=v=>T+PH-PH*v/ymax;
        for(let i=0;i<=4;i++) {
            const val=i*step, yy=y(val);
            svg.append(svgElement("line",{x1:L,y1:yy,x2:W-R,y2:yy,stroke:"#e8e8e8"}));
            svg.append(svgElement("text",{x:L-12,y:yy+4,"text-anchor":"end","font-size":12,fill:"#666"},val));
        }
        svg.append(svgElement("line",{x1:L,y1:T,x2:L,y2:T+PH,stroke:"#555","stroke-width":1.5}));
        svg.append(svgElement("line",{x1:L,y1:T+PH,x2:W-R,y2:T+PH,stroke:"#555","stroke-width":1.5}));
        svg.append(svgElement("text",{x:18,y:T+PH/2,transform:"rotate(-90 18 "+(T+PH/2)+")","text-anchor":"middle","font-size":13,fill:"#444"},"Number of orders"));
        svg.append(svgElement("text",{x:L+PW/2,y:H-10,"text-anchor":"middle","font-size":13,fill:"#444"},monthly?"Month":"Order date"));
        const labelStep=Math.max(1,Math.ceil(data.length/9));
        data.forEach((d,i)=>{
            if(i%labelStep!==0 && i!==data.length-1)return;
            const label=monthly ? d.date : niceDate(d.date).slice(0,5);
            svg.append(svgElement("text",{x:x(i),y:T+PH+24,"text-anchor":"middle","font-size":11,fill:"#666"},label));
        });
        if(chartType === "line") {
            const path=data.map((d,i)=>(i===0?"M":"L")+x(i)+" "+y(d.count)).join(" ");
            svg.append(svgElement("path",{d:path,fill:"none",stroke:"#ff6b00","stroke-width":3,"stroke-linejoin":"round","stroke-linecap":"round"}));
            data.forEach((d,i)=>{
                const circle=svgElement("circle",{cx:x(i),cy:y(d.count),r:5,fill:"#ff6b00",stroke:"white","stroke-width":2});
                circle.append(svgElement("title",{},d.date+": "+d.count+" orders"));svg.append(circle);
            });
        } else {
            const barWidth=Math.min(42,Math.max(2,PW/data.length*.7));
            data.forEach((d,i)=>{
                const bar=svgElement("rect",{x:x(i)-barWidth/2,y:y(d.count),width:barWidth,height:T+PH-y(d.count),rx:3,fill:"#ff6b00"});
                bar.append(svgElement("title",{},d.date+": "+d.count+" orders"));svg.append(bar);
            });
        }
    }
    function refresh() {
        const from=byId("fromDate").value,to=byId("toDate").value,r=byId("restaurantFilter").value;
        const query=byId("searchFilter").value.trim().toLowerCase();
        filtered=orders.filter(o=>(!from || (o.date && o.date>=from)) && (!to || (o.date && o.date<=to)) && (r==="all" || o.restaurantId===r) && (!query || [o.id,o.customer,o.restaurant,o.payment,o.status].join(" ").toLowerCase().includes(query)));
        renderList();renderCards();drawChart();
        byId("resultSummary").textContent=filtered.length+" of "+orders.length+" orders shown";
    }
    function switchView(view) {
        activeView=view;
        byId("listPanel").classList.toggle("hidden",view!=="list");
        byId("cardsPanel").classList.toggle("hidden",view!=="cards");
        byId("graphPanel").classList.toggle("hidden",view!=="graph");
        document.querySelectorAll(".view-button").forEach(b=>{b.classList.toggle("active",b.dataset.view===view);b.setAttribute("aria-pressed",String(b.dataset.view===view));});
        if(view==="graph")drawChart();
    }
    document.querySelectorAll(".view-button").forEach(b=>b.addEventListener("click",()=>switchView(b.dataset.view)));
    document.querySelectorAll(".chart-button").forEach(b=>b.addEventListener("click",()=>{
        chartType=b.dataset.chart;
        document.querySelectorAll(".chart-button").forEach(x=>x.classList.toggle("active",x.dataset.chart===chartType));
        drawChart();
    }));
    byId("applyFilters").addEventListener("click",refresh);
    byId("clearFilters").addEventListener("click",()=>{byId("fromDate").value="";byId("toDate").value="";byId("restaurantFilter").value="all";byId("searchFilter").value="";refresh();});
    ["fromDate","toDate","restaurantFilter","groupBy"].forEach(id=>byId(id).addEventListener("change",refresh));
    byId("searchFilter").addEventListener("input",refresh);
    refresh();switchView("list");
})();
</script>
</body>
</html>
