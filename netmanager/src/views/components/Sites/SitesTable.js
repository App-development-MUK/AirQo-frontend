import React, { useState, useEffect } from "react";
import { useDispatch } from "react-redux";
import { useHistory } from "react-router-dom";
import LoadingOverlay from "react-loading-overlay";
import { isEmpty } from "underscore";
import Tooltip from "@material-ui/core/Tooltip";
import DeleteIcon from "@material-ui/icons/DeleteOutlineOutlined";
import { loadSitesData } from "redux/SiteRegistry/operations";
import { useSitesArrayData } from "redux/SiteRegistry/selectors";
import CustomMaterialTable from "../Table/CustomMaterialTable";
import ConfirmDialog from "../../containers/ConfirmDialog";
import { deleteSiteApi } from "views/apis/deviceRegistry";
import { updateMainAlert } from "redux/MainAlert/operations";


// css
import "assets/css/location-registry.css";

const SitesTable = () => {
  const history = useHistory();
  const dispatch = useDispatch();
  const sites = useSitesArrayData();

  const [isLoading, setIsLoading] = useState(false);
  const [delState, setDelState] = useState({ open: false, name: "", id: "" });

  useEffect(() => {
    //code to retrieve all locations data
    if (isEmpty(sites)) {
      setIsLoading(true);
      dispatch(loadSitesData());
      setIsLoading(false);
    }
  }, []);

  const handleDeleteSite = (e) => {
    setDelState({ open: false, name: "", id: "" });
    deleteSiteApi(delState.id)
      .then((resData) => {
        dispatch(loadSitesData());
        dispatch(
          updateMainAlert({
            message: resData.message,
            show: true,
            severity: "success",
          })
        );
      })
      .catch((error) => {
        dispatch(
          updateMainAlert({
            message:
              error.response &&
              error.response.data &&
              error.response.data.message,
            show: true,
            severity: "error",
          })
        );
      });
  };

  return (
    <>
      <LoadingOverlay active={isLoading} spinner text="Loading Locations...">
        <CustomMaterialTable
          pointerCursor
          userPreferencePaginationKey={"sites"}
          title="Site Registry"
          columns={[
            {
              title: "Name",
              field: "name",
              render: (rowData) => (
                <span>
                  {rowData.name ||
                    rowData.description ||
                    rowData.formated_name ||
                    rowData.generated_name}
                </span>
              ),
            },
            {
              title: "Latitude",
              field: "latitude",
              cellStyle: { fontFamily: "Open Sans" },
            },
            {
              title: "Longitude",
              field: "longitude",
              cellStyle: { fontFamily: "Open Sans" },
            },
            {
              title: "County",
              field: "county",
              cellStyle: { fontFamily: "Open Sans" },
            },
            {
              title: "District",
              field: "district",
              cellStyle: { fontFamily: "Open Sans" },
            },
            {
              title: "Region",
              field: "region",
              cellStyle: { fontFamily: "Open Sans" },
            },
            {
              title: "Altitude",
              field: "altitude",
              cellStyle: { fontFamily: "Open Sans" },
            },
            {
              title: "Actions",
              render: (rowData) => (
                <div>
                  <Tooltip title="Delete">
                    <DeleteIcon
                      className={"hover-red"}
                      // style={{
                      //   margin: "0 5px",
                      //   cursor: "not-allowed",
                      //   color: "grey",
                      // }}
                      // disable deletion for now
                      onClick={(event) => {
                        event.stopPropagation();
                        setDelState({
                          open: true,
                          name: rowData.name || rowData.description,
                          id: rowData._id,
                        });
                      }}
                    />
                  </Tooltip>
                </div>
              ),
            },
          ]}
          onRowClick={(event, data) => {
            event.preventDefault();
            history.push(`/sites/${data._id}`);
          }}
          data={sites}
          options={{
            search: true,
            exportButton: true,
            searchFieldAlignment: "left",
            showTitle: false,
            searchFieldStyle: {
              fontFamily: "Open Sans",
            },
            headerStyle: {
              fontFamily: "Open Sans",
              fontSize: 16,
              fontWeight: 600,
            },
          }}
        />
      </LoadingOverlay>
      <ConfirmDialog
        open={delState.open}
        title={"Delete a site?"}
        message={`Are you sure you want to delete this ${delState.name} site`}
        close={() => setDelState({ open: false, name: "", id: "" })}
        confirm={handleDeleteSite}
        error
      />
    </>
  );
};

export default SitesTable;
