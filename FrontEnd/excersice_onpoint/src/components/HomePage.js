import React, { useState, useRef } from "react";
import axios from "axios";
import BootstrapTable from "react-bootstrap-table-next";
import paginationFactory from "react-bootstrap-table2-paginator";
import ReactLoading from "react-loading";
import ToolkitProvider, {
  Search,
  ColumnToggle,
} from "react-bootstrap-table2-toolkit/dist/react-bootstrap-table2-toolkit";
import filterFactory, { textFilter } from "react-bootstrap-table2-filter";
import PropTypes from "prop-types";

const TestPage = () => {
  //#region Properties
  const [url, setUrl] = useState("");
  // const [players, setPlayer] = useState([]);
  const [movies, setMovie] = useState([]);
  const [isShowLoading, setisShowLoading] = useState(true);
  const [totalSizeDataConfig, setTotalSizeDataConfig] = useState(0);
  const [sizePerPageConfig, setSizePerPageConfig] = useState(20);
  const [pageConfig, setPageConfig] = useState(1);
  const inputFile = useRef(null);

  const linkGetMovieByCaterogies =
    "http://localhost:4000/api/getcategories?url=";
  const linkImportDataRoot = "http://localhost:4000/api/importmovie";
  const linkImportByLink = "http://localhost:4000/api/importbylink?link=";
  const linkGetMovieByPage =
    "http://localhost:4000/api/getmoviebypage?pagenumber=";
  const linkGetAllMovie = "http://localhost:4000/api/getall";
  const getLink_GetMovie_ByPage_HasFilter = (pagenumber, director, nation) =>
    `http://localhost:4000/api/getmoviebypageandfilter?pagenumber=${pagenumber}&director=${director}&nation=${nation}`;
  //#endregion Properties

  //#region Functions
  const getMovieData = async (movie_link) => {
    try {
      let linkFilm = linkGetMovieByCaterogies.concat(movie_link);
      console.log("Link category film's: " + linkFilm);
      const moviedata = await axios.get(linkFilm);
      if (moviedata.status == 200) {
        console.log(moviedata);
        moviedata.data.items.forEach((element) => {
          setMovie((prevState) => [...prevState, element]);
        });
      } else {
        alert("Get data movie failure");
      }
    } catch (error) {
      alert("Get data movie failure");
      console.log(error);
    }
    setisShowLoading(true);
  };

  const importMovieDataByLink = async (movie_link) => {
    try {
      setisShowLoading(false);
      let linkFilm = linkImportByLink.concat(movie_link);
      console.log("Link category film's: " + linkFilm);
      const moviedata = await axios.get(linkFilm);
      console.log(moviedata.data);
      if (moviedata.status == 200) {
        alert("Import data movie successs");
      } else {
        alert("Import data movie failure");
      }
    } catch (error) {
      alert("Import data movie failure");
      console.log(error);
    }
    setisShowLoading(true);
  };

  const getAllMovie = async () => {
    try {
      setisShowLoading(false);
      setMovie([]);
      let link = linkGetAllMovie;
      const moviedata = await axios.get(link);
      console.log(moviedata.data);
      console.log("total count: " + moviedata.data.totalcountmovie);
      setTotalSizeDataConfig(moviedata.data.totalcountmovie);
      if (moviedata.status == 200) {
        moviedata.data.items.forEach((element) => {
          setMovie((prevState) => [...prevState, element]);
        });
      } else {
        alert("Get data movie failure");
      }
    } catch (error) {
      alert("Get data movie failure");
      console.log(error);
    }
    setisShowLoading(true);
  };

  const getMovieByUrl = () => {
    setisShowLoading(false);
    console.log("Url: " + url);
    setMovie([]);
    getMovieData(url);
  };

  const getMovieByPage_HasFilter = async (
    pagenumber,
    filter_director,
    filter_nation
  ) => {
    setMovie([]);
    let url = getLink_GetMovie_ByPage_HasFilter(
      pagenumber,
      filter_director,
      filter_nation
    );
    const data = await axios.get(url);
    if (data.status == 200) {
      console.log("data receiver: ", data.data);
      setTotalSizeDataConfig(data.data.total);
      data.data.items.forEach((element) => {
        setMovie((prevState) => [...prevState, element]);
      });
    } else {
      alert("Get data movie failure");
    }
  };

  const onFileSelect = (e) => {
    let file = e.target.files;
    let reader = new FileReader();
    reader.readAsText(file[0]);
    reader.onload = (e) => {
      const text = e.target.result;
      const listURL = text.split("\n");
      listURL.forEach((element) => {
        console.log("Link categories movie's: " + element);
        setisShowLoading(false);
        setMovie([]);
        getMovieData(element);
      });
    };
  };

  const importByUrl = () => {
    setMovie([]);
    importMovieDataByLink(url);
  };

  const exportFile2JSon = () => {
    // e.preventDefault();
    downloadFile({
      data: JSON.stringify(movies),
      fileName: "movies.json",
      fileType: "text/json",
    });
  };

  const downloadFile = ({ data, fileName, fileType }) => {
    // Create a blob with the data we want to download as a file
    const blob = new Blob([data], { type: fileType });
    // Create an anchor element and dispatch a click event on it
    // to trigger a download
    const a = document.createElement("a");
    a.download = fileName;
    a.href = window.URL.createObjectURL(blob);
    const clickEvt = new MouseEvent("click", {
      view: window,
      bubbles: true,
      cancelable: true,
    });
    a.dispatchEvent(clickEvt);
    a.remove();
  };

  const importData = async () => {
    setisShowLoading(false);
    try {
      const result_import = await axios.post(linkImportDataRoot, movies);
      console.log(result_import);
      if (result_import.status == 200) {
        alert("Import data success");
      } else {
        alert("Import data failure");
      }
    } catch (error) {
      console.log(error);
      alert("Import data failure");
    }
    setisShowLoading(true);
  };

  //#endregion Functions

  //#region React-Table
  const columns = [
    {
      dataField: "thumnail",
      text: "Movie image",
      style: { textAlign: "center" },
      formatter: (cell) => {
        return (
          <>
            {cell.map((label) => (
              <img
                src={label}
                key={label}
                alt=""
                style={{ maxWidth: "60%" }}
              ></img>
            ))}
          </>
        );
      },
    },
    { dataField: "title", text: "Movie name" },
    {
      dataField: "link",
      text: "Movie link",
      formatter: (cell) => {
        return (
          <>
            {cell.map((urlmovie) => (
              <a href={urlmovie}>{urlmovie}</a>
            ))}
          </>
        );
      },
    },
    {
      dataField: "director",
      text: "Director",
      filter: textFilter(),
    },
    { dataField: "nation", text: "Nation", filter: textFilter() },
    { dataField: "year", text: "Year public" },
    { dataField: "num_of_episode", text: "Movie episode" },
  ];

  const pagination = paginationFactory({
    page: pageConfig,
    totalSize: totalSizeDataConfig,
    sizePerPage: sizePerPageConfig,
    showTotal: true,
    alwaysShowAllBtns: true,
    sizePerPageList: [
      //   {
      //     text: "5",
      //     value: 5,
      //   },
      //   {
      //     text: "10",
      //     value: 10,
      //   },
      //   {
      //     text: "15",
      //     value: 15,
      //   },
      {
        text: "20",
        value: 20,
      },
    ],
  });

  const defaultSorted = [
    {
      dataField: "director",
      order: "desc",
    },
  ];

  BootstrapTable.propTypes = {
    data: PropTypes.array.isRequired,
    page: PropTypes.number.isRequired,
    totalSize: PropTypes.number.isRequired,
    sizePerPage: PropTypes.number.isRequired,
    onTableChange: PropTypes.func.isRequired,
  };

  const handleTableChange = (type, { page, sizePerPage, filters }) => {
    // console.log("Filter: ", filters);
    let director =
      filters.director !== undefined ? filters.director.filterVal : "";
    let nation = filters.nation !== undefined ? filters.nation.filterVal : "";
    console.log(`Filter director: ${director}`);
    console.log(`Filter nation: ${nation}`);
    getMovieByPage_HasFilter(page, director, nation);
    setPageConfig(page);
  };

  //#endregion React-Table

  return (
    <>
      <div className="jumbotron">
        <h1>EXERCISE 2-ONPOINT</h1>
      </div>

      <div>
        <div className="form-group row" style={{ marginLeft: "0.8rem" }}>
          <label className="col-sm-2 col-form-label">Enter URL:</label>
          <div className="col-sm-10">
            <input
              className="form-control"
              placeholder="input URL movie's here"
              type="text"
              ref={inputFile}
              value={url}
              onChange={(e) => setUrl(e.target.value)}
            />
          </div>
        </div>
        <div
          className="float-right"
          style={{ margin: "0rem 0.4rem 1.2rem 0rem" }}
        >
          <button
            className="btn btn-primary"
            onClick={() => getMovieByUrl()}
            style={{ marginLeft: "0.4rem" }}
          >
            Get movie by URL
          </button>

          <div
            style={{ marginLeft: "0.4rem" }}
            className="fileUpload btn btn-success btn-sm"
          >
            <span>Upload</span>
            <input
              type="file"
              name="file"
              onChange={(e) => onFileSelect(e)}
            />{" "}
          </div>

          <button
            className="btn btn-info"
            onClick={() => exportFile2JSon()}
            style={{ marginLeft: "0.4rem" }}
          >
            Export file
          </button>

          <button
            className="btn btn-warning"
            onClick={() => importData()}
            style={{ marginLeft: "0.4rem" }}
          >
            Import data
          </button>

          <button
            className="btn btn-warning"
            onClick={() => importByUrl()}
            style={{ marginLeft: "0.4rem" }}
          >
            Import data from link
          </button>

          <button
            className="btn btn-secondary"
            onClick={() => getAllMovie()}
            style={{ marginLeft: "0.4rem" }}
          >
            Get movie
          </button>
        </div>
      </div>
      <div style={{ margin: "4rem 0.4rem 0.4rem 1.2rem" }}>
        <>
          {!isShowLoading ? (
            <ReactLoading
              type={"bars"}
              color={"#03fc4e"}
              height={100}
              width={100}
            />
          ) : (
            // <ToolkitProvider
            //   bootstrap4
            //   keyField="link"
            //   data={movies}
            //   columns={columns}
            //   search
            // >
            //   {(props) => (
            //     <div>
            //       <BootstrapTable
            //         defaultSorted={defaultSorted}
            //         pagination={pagination}
            //         {...props.baseProps}
            //         filter={filterFactory()}
            //       />
            //     </div>
            //   )}
            // </ToolkitProvider>

            <BootstrapTable
              remote
              keyField="link"
              page={pageConfig}
              data={movies}
              columns={columns}
              defaultSorted={defaultSorted}
              filter={filterFactory()}
              pagination={pagination}
              onTableChange={handleTableChange}
            />
            // <BootstrapTable
            //   keyField="link"
            //   data={movies}
            //   columns={columns}
            //   pagination={pagination}
            // />
          )}
        </>
      </div>
    </>
  );
};

export default TestPage;
