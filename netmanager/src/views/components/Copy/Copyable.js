import React, { useState, useRef } from "react";
import { useDispatch } from "react-redux";
import CopyIcon, { CopySuccessIcon } from "assets/img/CopyIcon";
import { updateMainAlert } from "redux/MainAlert/operations";

const Copyable = ({ value, className, width, format }) => {
  const copyRef = useRef();
  const [copied, setCopied] = useState(false);
  const dispatch = useDispatch();

  const onClick = () => {
    // let comp = document.getElementById(componentID);
    let comp = copyRef.current;
    let textArea = document.createElement("textarea");
    textArea.value = comp.textContent;
    document.body.appendChild(textArea);
    /* Select the text field */
    textArea.select();
    textArea.setSelectionRange(0, 99999); /* For mobile devices */

    /* Copy the text inside the text field */
    document.execCommand("copy");
    textArea.remove();
    setCopied(true);
    dispatch(
      updateMainAlert({
        show: true,
        message: `Successfully copied to clipboard. ${
          format ? "format - " + format : ""
        }`,
        severity: "info",
      })
    );
    setTimeout(() => setCopied(false), 1000);
  };
  return (
    <div
      style={{
        display: "flex",
        alignItems: "center",
        justifyContent: "space-between",
      }}
    >
      <span
        ref={copyRef}
        style={{
          width: width || "200px",
          textOverflow: "ellipsis",
          whiteSpace: "nowrap",
          overflow: "hidden",
        }}
      >
        {value}
      </span>
      {copied ? (
        <CopySuccessIcon />
      ) : (
        <CopyIcon onClick={onClick} className={className} />
      )}
    </div>
  );
};

export default Copyable;
