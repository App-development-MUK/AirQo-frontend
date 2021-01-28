import React from "react";

export const PieChartIcon = ({ className, style, width, onClick }) => {
  return (
    <svg
      className={className || ""}
      style={style || {}}
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 24 24"
      width={width || "24"}
      onClick={onClick}
    >
      <path d="M0 0h24v24H0V0z" fill="none" />
      <path d="M11 2v20c-5.07-.5-9-4.79-9-10s3.93-9.5 9-10zm2.03 0v8.99H22c-.47-4.74-4.24-8.52-8.97-8.99zm0 11.01V22c4.74-.47 8.5-4.25 8.97-8.99h-8.97z" />
    </svg>
  );
};
