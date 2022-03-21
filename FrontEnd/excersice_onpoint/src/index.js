import "bootstrap/dist/css/bootstrap.min.css";
import React from "react";
import { render } from "react-dom";
import HomePage from "./components/HomePage";
import AboutPage from "./components/AboutPage";
import "react-bootstrap-table-next/dist/react-bootstrap-table2.min.css";
import "react-bootstrap-table2-paginator/dist/react-bootstrap-table2-paginator.min.css";
import "bootstrap/dist/css/bootstrap.min.css";
import TestPage from "./components/TestPage";

render(<HomePage></HomePage>, document.getElementById("root"));
// render(<AboutPage></AboutPage>, document.getElementById("root"));
// render(<TestPage></TestPage>, document.getElementById("root"));
