module Web.View.Requests.Show where
import Web.View.Prelude

data ShowView = ShowView { request :: Request }

instance View ShowView where
    html ShowView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={RequestsAction}>Requests</a></li>
                <li class="breadcrumb-item active">Show Request</li>
            </ol>
        </nav>
        <h1>Show Request</h1>
        <p>{request}</p>
    |]
