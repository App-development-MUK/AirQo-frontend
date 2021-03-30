/* eslint-disable react/no-multi-comp */
/* eslint-disable react/display-name */
import React, { forwardRef } from "react";
import { NavLink as RouterLink } from "react-router-dom";
import clsx from "clsx";
import PropTypes from "prop-types";
import { makeStyles } from "@material-ui/styles";
import { List, ListItem, Button, colors } from "@material-ui/core";

const useStyles = makeStyles((theme) => ({
  root: {
    width: "100%",
    maxWidth: 360,
    backgroundColor: theme.palette.background.paper,
  },
  nested: {
    paddingLeft: theme.spacing(4),
  },
  item: {
    display: "flex",
    paddingTop: 0,
    paddingBottom: 0,
  },
  button: {
    color: colors.blueGrey[800],
    padding: "10px 8px",
    justifyContent: "flex-start",
    textTransform: "none",
    letterSpacing: 0,
    width: "100%",
    fontWeight: theme.typography.fontWeightMedium,
  },
  icon: {
    color: theme.palette.icon,
    width: 24,
    height: 24,
    display: "flex",
    alignItems: "center",
    marginRight: theme.spacing(1),
  },
  active: {
    color: theme.palette.primary.main,
    fontWeight: theme.typography.fontWeightMedium,
    "& $icon": {
      color: theme.palette.primary.main,
    },
  },
}));

const CustomRouterLink = forwardRef((props, ref) => (
  <div ref={ref} style={{ flexGrow: 1 }}>
    <RouterLink {...props} />
  </div>
));

const SidebarNav = (props) => {
  const classes = useStyles();
  const { pages, className, ...rest } = props;

  const [open, setOpen] = React.useState(true);

  const handleClick = () => {
    setOpen(!open);
  };

  const collapsePage = (page) => {
    return page.collapse === true;
  };
  const normalPage = (page) => {
    return page.collapse == false;
  };

  const collapsePages = pages.filter(collapsePage);
  const normalPages = pages.filter(normalPage);

  // if (!collapsePages.isArray(array) || !collapsePages.length) {
  //   // array does not exist, is not an array, or is empty
  //   // ⇒ do not attempt to process array
  //   jsx = (
  //     <div>
  //       <ListItem button onClick={handleClick}>
  //         <ListItemIcon>
  //           <InboxIcon />
  //         </ListItemIcon>
  //         <ListItemText primary="Inbox" />
  //         {open ? <ExpandLess /> : <ExpandMore />}
  //       </ListItem>
  //       <Collapse in={open} timeout="auto" unmountOnExit>
  //         <List component="div" disablePadding>
  //           <ListItem button className={classes.nested}>
  //             <ListItemIcon>
  //               <StarBorder />
  //             </ListItemIcon>
  //             <ListItemText primary="Starred" />
  //           </ListItem>
  //         </List>
  //       </Collapse>
  //     </div>
  //   );
  // } else {
  // }

  return (
    <List {...rest} className={clsx(classes.root, className)}>
      {pages.map((page) => (
        <ListItem className={classes.item} disableGutters key={page.title}>
          <Button
            activeClassName={classes.active}
            className={classes.button}
            component={CustomRouterLink}
            to={page.href}
          >
            <div className={classes.icon}>{page.icon}</div>
            {page.title}
          </Button>
        </ListItem>
      ))}
    </List>
  );
};

SidebarNav.propTypes = {
  className: PropTypes.string,
  pages: PropTypes.array.isRequired,
};

export default SidebarNav;
