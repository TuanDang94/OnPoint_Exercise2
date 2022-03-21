import React, { useState, useRef } from "react";
import axios from "axios";
import BootstrapTable from "react-bootstrap-table-next";
import paginationFactory from "react-bootstrap-table2-paginator";
import ReactLoading from "react-loading";

const HomePage = () => {
  const [url, setUrl] = useState("");
  // const [players, setPlayer] = useState([]);
  const [movies, setMovie] = useState([]);
  const [done, setDone] = useState(true);
  const inputFile = useRef(null);
  const linkRoot = "http://localhost:4000/api/getcategories?url=";

  const getMovieData = async (movie_link) => {
    try {
      let linkFilm = linkRoot.concat(movie_link);
      console.log("Link category film's: " + linkFilm);
      const moviedata = await axios.get(linkFilm);
      moviedata.data.forEach((element) => {
        element.items.forEach((item) => {
          setMovie((prevState) => [...prevState, item]);
        });
      });
    } catch (error) {
      console.log(error);
    }
    setDone(true);
  };

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
    { dataField: "year", text: "Year public" },
    { dataField: "number_of_episode", text: "Movie episode" },
  ];

  const getMovieByUrl = () => {
    setDone(false);
    console.log("Url: " + url);
    setMovie([]);
    getMovieData(url);
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
        setDone(false);
        setMovie([]);
        getMovieData(element);
      });
    };
  };

  const pagination = paginationFactory({
    sizePerPage: 20,
    showTotal: true,
    alwaysShowAllBtns: true,
    sizePerPageList: [
      {
        text: "5",
        value: 5,
      },
      {
        text: "10",
        value: 10,
      },
      {
        text: "15",
        value: 15,
      },
      {
        text: "20",
        value: 20,
      },
    ],
  });

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

  return (
    <>
      <div className="jumbotron">
        <h1>EXERCISE 2-ONPOINT</h1>
      </div>

      <div>
        <div className="form-group row" style={{ marginLeft: "10px" }}>
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
        <div className="float-right" style={{ margin: "0px 5px 15px 0px" }}>
          <button
            className="btn btn-primary"
            onClick={() => getMovieByUrl()}
            style={{ marginLeft: "5px" }}
          >
            Get movie by URL
          </button>

          <div
            style={{ marginLeft: "5px" }}
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
            style={{ marginLeft: "5px" }}
          >
            Export file
          </button>
        </div>
      </div>
      <div>
        <>
          {!done ? (
            <ReactLoading
              type={"bars"}
              color={"#03fc4e"}
              height={100}
              width={100}
            />
          ) : (
            <BootstrapTable
              keyField="link"
              data={movies}
              columns={columns}
              pagination={pagination}
            />
          )}
        </>
      </div>
    </>
  );
};

export default HomePage;
