import { Outlet, NavLink, Link } from "react-router-dom";

import styles from "./Layout.module.css";

const Layout = () => {
    return (
        <div className={styles.layout}>
            <header className={styles.header} role={"banner"}>
                <div className={styles.headerContainer}>
                    <Link to="/" className={styles.headerTitleContainer}>
                        <h3 className={styles.headerTitle}>Azure AI Lab</h3>
                    </Link>
                    <nav>
                        <ul className={styles.headerNavList}>
                            <li className={styles.headerNavLeftMargin}>
                                <a href="/design" >Design</a>
                            </li>
                            <li>
                                <a href="/translation" >Translation</a>
                            </li>
                            <li>
                                <a href="/vision" >Vision</a>
                            </li>
                            <li>
                                <a href="/speech" >Speech</a>
                            </li>
                            <li>
                                <a href="/seo" >SEO</a>
                            </li>
                        </ul>
                    </nav>
                    <h4 className={styles.headerRightText}>AI Services</h4>
                </div>
            </header>

            <Outlet />
        </div>
    );
};

export default Layout;
