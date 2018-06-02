<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="DBRefactoringW.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<link rel="stylesheet" href="~/Content/style.css"/>
    <title>DBリファクタリング</title>
    <style>
        .node {
            stroke: #fff;
            stroke-width: 1.5px;
        }
        .link {
            stroke: #999;
            stroke-opacity: .6;
        }
        .node text {
        font: 9px helvetica;
        }
    </style>
</head>
<body>
    <script type="application/json" id="mis4">
        {
            "nodes": [{
                "name": "電子会議",
                    "group": 1
            }, {
                "name": "電子会議番号",
                    "group": 1
            }, {
                "name": "議題",
                    "group": 1
            }, {
                "name": "分野番号",
                    "group": 2
            }, {
                "name": "分野名",
                    "group": 2
            }, {
                "name": "表示順",
                    "group": 1
            }, {
                "name": "作成者ユーザー",
                    "group": 1
            }, {
                "name": "投稿者ユーザーID",
                    "group": 1
            }, {
                "name": "投稿番号",
                    "group": 3
            }, {
                "name": "投稿本文",
                    "group": 3
            }, {
                "name": "投稿者ユーザーID",
                    "group": 3
            }],
                "links": [{
                "source": 1,
                    "target": 0,
                    "value": 1
            }, {
                "source": 2,
                    "target": 0,
                    "value": 8
            }, {
                "source": 3,
                    "target": 0,
                    "value": 10
            }, {
                "source": 4,
                    "target": 0,
                    "value": 1
            }, {
                "source": 5,
                    "target": 0,
                    "value": 1
            }, {
                "source": 6,
                    "target": 0,
                    "value": 1
            }, {
                "source": 7,
                    "target": 0,
                    "value": 1
            }, {
                "source": 8,
                    "target": 9,
                    "value": 1
            }, {
                "source": 9,
                    "target": 10,
                    "value": 2
            }]
        }
    </script>
    <form id="form1" runat="server">
        <h1>DBリファクタリングツール</h1>
        <div style ="float: left;">
            <asp:GridView ID="columnlist1" runat="server"></asp:GridView>
            <asp:GridView ID="grNullRel" runat="server"></asp:GridView>
        </div>
        <div style ="float: left;">
            <asp:GridView ID="grColumnRel" runat="server"></asp:GridView>
        </div>
        <!--<script type="text/javascript" src="libs/d3.js" charset="utf-8"></script>-->
        <br/>
        <div style ="clear: both;">

        </div>
        <h2>テーブルカラム間クラスタリング</h2>
        <div style ="float: left;">
            <asp:Label ID="Label2" runat="server" Text=""></asp:Label>
            <br/>
            <asp:GridView ID="columnlist2" runat="server"></asp:GridView>
            <asp:GridView ID="grColumnRel2" runat="server"></asp:GridView>
            <div class="svg_area" id="svg_area" style ="float: right;"></div>
        </div>
        <script src="http://d3js.org/d3.v3.min.js" charset="utf-8"></script>
    <script type="application/json" id="mis">
        {
            "nodes": [{
                "name": "電子会議",
                    "group": 1
            }, {
                "name": "電子会議番号",
                    "group": 1
            }, {
                "name": "議題",
                    "group": 1
            }, {
                "name": "分野番号",
                    "group": 2
            }, {
                "name": "分野名",
                    "group": 2
            }, {
                "name": "表示順",
                    "group": 1
            }, {
                "name": "作成者ユーザー",
                    "group": 1
            }, {
                "name": "投稿番号",
                    "group": 3
            }, {
                "name": "投稿本文",
                    "group": 3
            }, {
                "name": "投稿者ユーザーID",
                    "group": 3
            }],
                "links": [{
                "source": 1,
                    "target": 0,
                    "value": 1
            }, {
                "source": 2,
                    "target": 0,
                    "value": 8
            }, {
                "source": 3,
                    "target": 0,
                    "value": 10
            }, {
                "source": 4,
                    "target": 0,
                    "value": 1
            }, {
                "source": 5,
                    "target": 0,
                    "value": 1
            }, {
                "source": 6,
                    "target": 0,
                    "value": 1
            }, {
                "source": 7,
                    "target": 0,
                    "value": 1
            }, {
                "source": 8,
                    "target": 0,
                    "value": 2
            }, {
                "source": 9,
                    "target": 0,
                    "value": 1
            }]
        }
    </script>
    <script>
        //Constants for the SVG
        var width = 500,
            height = 500;

        //Set up the colour scale
        var color = d3.scale.category20();

        //Set up the force layout
        var force = d3.layout.force()
            .charge(-120)
            .linkDistance(100)
            .size([width, height]);

        //Append a SVG to the body of the html page. Assign this SVG as an object to svg
        var svg = d3.select("#svg_area").append("svg")
            .attr("width", width)
            .attr("height", height);

        //Read the data from the mis element 
        var mis = document.getElementById('mis').innerHTML;
        graph = JSON.parse(mis);

        //Creates the graph data structure out of the json data
        force.nodes(graph.nodes)
            .links(graph.links)
            .start();

        //Create all the line svgs but without locations yet
        var link = svg.selectAll(".link")
            .data(graph.links)
            .enter().append("line")
            .attr("class", "link")
            .style("stroke-width", function (d) {
                return Math.sqrt(d.value);
            });

        //Do the same with the circles for the nodes - no 
        var node = svg.selectAll(".node")
            .data(graph.nodes)
            .enter().append("g")
            .attr("class", "node")
            .call(force.drag);
        node.append("circle")
            .attr("r", 8)
            .style("fill", function (d) {
                return color(d.group);
            })
        node.append("text")
            .attr("dx", 10)
            .attr("dy", ".35em")
            .text(function (d) { return d.name })
            .style("stroke", "black");


        //Now we are giving the SVGs co-ordinates - the force layout is generating the co-ordinates which this code is using to update the attributes of the SVG elements
        force.on("tick", function () {
            link.attr("x1", function (d) {
                return d.source.x;
            })
                .attr("y1", function (d) {
                    return d.source.y;
                })
                .attr("x2", function (d) {
                    return d.target.x;
                })
                .attr("y2", function (d) {
                    return d.target.y;
                });

            node.attr("cx", function (d) {
                return d.x;
            })
                .attr("cy", function (d) {
                    return d.y;
                });

            d3.selectAll("circle").attr("cx", function (d) {
                return d.x;
            })
                .attr("cy", function (d) {
                    return d.y;
                });
            d3.selectAll("text").attr("x", function (d) {
                return d.x;
            })
                .attr("y", function (d) {
                    return d.y;
                });
        });
    </script>
            <script type="application/json" id="mis2">
        {
            "nodes": [{
                "name": "電子会議番号",
                    "group": 4
            }, {
                "name": "議題",
                    "group": 1
            }, {
                "name": "分野番号",
                    "group": 2
            }, {
                "name": "分野名",
                    "group": 2
            }, {
                "name": "表示順",
                    "group": 1
            }, {
                "name": "作成者ユーザー",
                    "group": 1
            }, {
                "name": "投稿番号",
                    "group": 3
            }, {
                "name": "投稿本文",
                    "group": 3
            }, {
                "name": "投稿者ユーザーID",
                    "group": 3
            }],
                "links": [{
                "source": 0,
                    "target": 1,
                    "value": 10
            }, {
                "source": 2,
                    "target": 1,
                    "value": 6
            }, {
                "source": 3,
                    "target": 2,
                    "value": 10
            }, {
                "source": 4,
                    "target": 2,
                    "value": 6
            }, {
                "source": 5,
                    "target": 2,
                    "value": 2
            }, {
                "source": 6,
                    "target": 3,
                    "value": 3
            }, {
                "source": 7,
                    "target": 6,
                    "value": 10
            }, {
                "source": 8,
                    "target": 7,
                    "value": 10
            }, {
                "source": 0,
                    "target": 1,
                    "value": 2
            }, {
                "source": 0,
                    "target": 2,
                    "value": 2
            }, {
                "source": 0,
                    "target": 3,
                    "value": 2
            }, {
                "source": 0,
                    "target": 4,
                    "value": 2
            }, {
                "source": 0,
                    "target": 5,
                    "value": 2
            }, {
                "source": 0,
                    "target": 6,
                    "value": 2
            }, {
                "source": 0,
                    "target": 7,
                    "value": 2
            }, {
                "source": 0,
                    "target": 8,
                    "value": 2
            }, {
                "source": 1,
                    "target": 1,
                    "value": 2
            }, {
                "source": 1,
                    "target": 2,
                    "value": 2
            }, {
                "source": 1,
                    "target": 3,
                    "value": 2
            }, {
                "source": 1,
                    "target": 4,
                    "value": 2
            }, {
                "source": 1,
                    "target": 5,
                    "value": 2
            }, {
                "source": 1,
                    "target": 6,
                    "value": 2
            }, {
                "source": 1,
                    "target": 7,
                    "value": 2
            }, {
                "source": 1,
                    "target": 8,
                    "value": 2
            }, {
                "source": 2,
                    "target": 1,
                    "value": 2
            }, {
                "source": 2,
                    "target": 2,
                    "value": 2
            }, {
                "source": 2,
                    "target": 3,
                    "value": 2
            }, {
                "source": 2,
                    "target": 4,
                    "value": 2
            }, {
                "source": 2,
                    "target": 5,
                    "value": 2
            }, {
                "source": 2,
                    "target": 6,
                    "value": 2
            }, {
                "source": 2,
                    "target": 7,
                    "value": 2
            }, {
                "source": 2,
                    "target": 8,
                    "value": 2
            }, {
                "source": 3,
                    "target": 1,
                    "value": 2
            }, {
                "source": 3,
                    "target": 2,
                    "value": 2
            }, {
                "source": 3,
                    "target": 3,
                    "value": 2
            }, {
                "source": 3,
                    "target": 4,
                    "value": 2
            }, {
                "source": 3,
                    "target": 5,
                    "value": 2
            }, {
                "source": 3,
                    "target": 6,
                    "value": 2
            }, {
                "source": 3,
                    "target": 7,
                    "value": 2
            }, {
                "source": 3,
                    "target": 8,
                    "value": 2
            }, {
                "source": 4,
                    "target": 1,
                    "value": 2
            }, {
                "source": 4,
                    "target": 2,
                    "value": 2
            }, {
                "source": 4,
                    "target": 3,
                    "value": 2
            }, {
                "source": 4,
                    "target": 4,
                    "value": 2
            }, {
                "source": 4,
                    "target": 5,
                    "value": 2
            }, {
                "source": 4,
                    "target": 6,
                    "value": 2
            }, {
                "source": 4,
                    "target": 7,
                    "value": 2
            }, {
                "source": 4,
                    "target": 8,
                    "value": 2
            }, {
                "source": 5,
                    "target": 1,
                    "value": 2
            }, {
                "source": 5,
                    "target": 2,
                    "value": 2
            }, {
                "source": 5,
                    "target": 3,
                    "value": 2
            }, {
                "source": 5,
                    "target": 4,
                    "value": 2
            }, {
                "source": 5,
                    "target": 5,
                    "value": 2
            }, {
                "source": 5,
                    "target": 6,
                    "value": 2
            }, {
                "source": 5,
                    "target": 7,
                    "value": 2
            }, {
                "source": 5,
                    "target": 8,
                    "value": 2
            }, {
                "source": 6,
                    "target": 1,
                    "value": 2
            }, {
                "source": 6,
                    "target": 2,
                    "value": 2
            }, {
                "source": 6,
                    "target": 3,
                    "value": 2
            }, {
                "source": 6,
                    "target": 4,
                    "value": 2
            }, {
                "source": 6,
                    "target": 5,
                    "value": 2
            }, {
                "source": 6,
                    "target": 6,
                    "value": 2
            }, {
                "source": 6,
                    "target": 7,
                    "value": 2
            }, {
                "source": 6,
                    "target": 8,
                    "value": 2
            }]
        }
    </script>
    
        <div style ="clear: both;">

        </div>
        <h2>カラム間クラスタリング</h2>
        <div style ="float: left;">
        <h3> Link threshold 0 <input type="range" id="thersholdSlider" name="points" value = "0" min="0" max="10" onchange="threshold(this.value)"/> 10 </h3>
        <asp:Button ID="Button1" runat="server" Text="分解SQL" />
        <asp:TextBox ID="createText" runat="server"></asp:TextBox>
            <br />
        <div class="svg_area2" id="svg_area2" style ="float: left;"></div>
        </div>
        <script>
            //Constants for the SVG
            var width = 500,
                height = 500;

            //Set up the colour scale
            var color = d3.scale.category20();

            //Set up the force layout
            var force = d3.layout.force()
                .charge(-120)
                .linkDistance(200)
                .size([width, height]);

            //Append a SVG to the body of the html page. Assign this SVG as an object to svg
            var svg = d3.select("#svg_area2").append("svg")
                .attr("width", width)
                .attr("height", height);

            //Read the data from the mis element 
            var mis2 = document.getElementById('mis2').innerHTML;
            //var mis2 = 
            graph = JSON.parse(mis2);
            graphRec = JSON.parse(JSON.stringify(graph));

            //Creates the graph data structure out of the json data
            force.nodes(graph.nodes)
                .links(graph.links)
                .start();

            //Create all the line svgs but without locations yet
            var link = svg.selectAll(".link")
                .data(graph.links)
                .enter().append("line")
                .attr("class", "link")
                .style("stroke-width", function (d) {
                    return Math.sqrt(d.value);
                });

            //Do the same with the circles for the nodes - no 
            var node = svg.selectAll(".node")
                .data(graph.nodes)
                .enter().append("g")
                .attr("class", "node")
                .call(force.drag);
            node.append("circle")
                .attr("r", 8)
                .style("fill", function (d) {
                    return color(d.group);
                })
            node.append("text")
                .attr("dx", 10)
                .attr("dy", ".35em")
                .text(function (d) { return d.name })
                .style("stroke", "black");


            //Now we are giving the SVGs co-ordinates - the force layout is generating the co-ordinates which this code is using to update the attributes of the SVG elements
            force.on("tick", function () {
                link.attr("x1", function (d) {
                    return d.source.x;
                })
                    .attr("y1", function (d) {
                        return d.source.y;
                    })
                    .attr("x2", function (d) {
                        return d.target.x;
                    })
                    .attr("y2", function (d) {
                        return d.target.y;
                    });

                node.attr("cx", function (d) {
                    return d.x;
                })
                    .attr("cy", function (d) {
                        return d.y;
                    });

                d3.selectAll("circle").attr("cx", function (d) {
                    return d.x;
                })
                    .attr("cy", function (d) {
                        return d.y;
                    });
                d3.selectAll("text").attr("x", function (d) {
                    return d.x;
                })
                    .attr("y", function (d) {
                        return d.y;
                    });
            });

            //adjust threshold
            function threshold(thresh) {
                graph.links.splice(0, graph.links.length);
                for (var i = 0; i < graphRec.links.length; i++) {
                    if (graphRec.links[i].value > thresh) { graph.links.push(graphRec.links[i]); }
                }
                restart();
            }
            //Restart the visualisation after any node and link changes
            function restart() {
                link = link.data(graph.links);
                link.exit().remove();
                link.enter().insert("line", ".node").attr("class", "link");
                node = node.data(graph.nodes);
                node.enter().insert("circle", ".cursor").attr("class", "node").attr("r", 5).call(force.drag);
                force.start();
            }
    </script>
        <div style ="clear: both;">

        </div>
        <h2>新規カラム追加</h2>
        <div style ="float: left;">
        <asp:TextBox ID="txtaddcol" runat="server"></asp:TextBox>
            <br />
            <asp:GridView ID="grNewAddCol" runat="server"></asp:GridView>
        <div class="svg_area2" id="svg_area3" style ="float: left;"></div>
        </div>
        <div style ="clear: both;">

        </div>
        <h2>無損失分解</h2>
        <div style ="float: left;">
        <asp:TextBox ID="txtDiv" runat="server"></asp:TextBox>
            <br />
            <asp:GridView ID="grdivideCol" runat="server"></asp:GridView>
        <div class="svg_area2" id="svg_area4" style ="float: left;"></div>
        </div>
        <script>
            //Constants for the SVG
            var width = 500,
                height = 500;

            //Set up the colour scale
            var color = d3.scale.category20();

            //Set up the force layout
            var force = d3.layout.force()
                .charge(-120)
                .linkDistance(100)
                .size([width, height]);

            //Append a SVG to the body of the html page. Assign this SVG as an object to svg
            var svg = d3.select("#svg_area4").append("svg")
                .attr("width", width)
                .attr("height", height);

            //Read the data from the mis element 
            var mis = document.getElementById('mis4').innerHTML;
            graph = JSON.parse(mis);

            //Creates the graph data structure out of the json data
            force.nodes(graph.nodes)
                .links(graph.links)
                .start();

            //Create all the line svgs but without locations yet
            var link = svg.selectAll(".link")
                .data(graph.links)
                .enter().append("line")
                .attr("class", "link")
                .style("stroke-width", function (d) {
                    return Math.sqrt(d.value);
                });

            //Do the same with the circles for the nodes - no 
            var node = svg.selectAll(".node")
                .data(graph.nodes)
                .enter().append("g")
                .attr("class", "node")
                .call(force.drag);
            node.append("circle")
                .attr("r", 8)
                .style("fill", function (d) {
                    return color(d.group);
                })
            node.append("text")
                .attr("dx", 10)
                .attr("dy", ".35em")
                .text(function (d) { return d.name })
                .style("stroke", "black");


            //Now we are giving the SVGs co-ordinates - the force layout is generating the co-ordinates which this code is using to update the attributes of the SVG elements
            force.on("tick", function () {
                link.attr("x1", function (d) {
                    return d.source.x;
                })
                    .attr("y1", function (d) {
                        return d.source.y;
                    })
                    .attr("x2", function (d) {
                        return d.target.x;
                    })
                    .attr("y2", function (d) {
                        return d.target.y;
                    });

                node.attr("cx", function (d) {
                    return d.x;
                })
                    .attr("cy", function (d) {
                        return d.y;
                    });

                d3.selectAll("circle").attr("cx", function (d) {
                    return d.x;
                })
                    .attr("cy", function (d) {
                        return d.y;
                    });
                d3.selectAll("text").attr("x", function (d) {
                    return d.x;
                })
                    .attr("y", function (d) {
                        return d.y;
                    });
            });
    </script>
        <div style ="clear: both;">

        </div>
        <h2>カラム名変更</h2>
        <div style ="float: left;">
        <asp:TextBox ID="TextBox2" runat="server"></asp:TextBox>
            <br />
            <asp:GridView ID="grRenameCol" runat="server" ViewStateMode="Enabled"></asp:GridView>
        <div class="svg_area2" id="svg_area5" style ="float: left;"></div>
        </div>
    </form>
</body>
</html>
