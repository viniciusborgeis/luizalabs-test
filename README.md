<h1 align="center">
  <br>
  <img width="100%" src="https://raw.githubusercontent.com/viniciusborgeis/luizalabs-test/feature/add-readme/banner.png" alt="Coinbase Commerce Client">
  <br>
  Luizalabs Test
  <br>
</h1>

<h4 align="center">A olimpic games RESTful API writed in Ruby on Rails</h4>

<p align="center">
	<img src="https://raw.githubusercontent.com/viniciusborgeis/luizalabs-test/feature/add-readme/badge.svg" alt="Coverage">
	<img src="https://badgen.net/github/commits/viniciusborgeis/luizalabs-test/develop" alt="Commits">
</p>

<p align="center">
  <a href="#ruby-version">Ruby Version</a> •
  <a href="#what-do-i-do">What do i do</a> •
  <a href="#clean-architecture-overview">Architecture Overview</a> •
  <a href="#endpoints">Endpoints</a> •
  <a href="#installation">Setup</a> •
  <a href="#installation">Tests</a> •
  <a href="#usage">Usage</a>
</p>
<sub>Project writed for luizalabs test, fully created in ruby on rails, follow the best clean archtecture pratices.</sub>

## Ruby Version
Ruby [3.2.2] are supported and tested.

## What do i do

Our project is a RESTful API built using Ruby on Rails for the Brazilian Olympic Committee (COB). The API's primary function is to manage and record the results of various Olympic events. Specifically, it handles competitions for events like the 100m sprint and javelin throw.

Through our API, users can:

Create a competition, providing details like the event name, event opened, and unit of measurement (e.g., seconds, meters).
Register results for a competition, including athlete details, the result value, and the unit of measurement.
Finalize a competition, marking it as closed.
Retrieve the ranking of a competition, displaying the final positions of each athlete.
The API enforces certain rules, such as not allowing result registration for closed competitions and providing partial rankings for ongoing competitions. For the javelin throw, each athlete gets three attempts, and the farthest distance is considered.

We've designed the API according to the principles of Clean Architecture and SOLID principles. We've separated the codebase into distinct layers like Models, Use Cases, Controllers, and Gateways to ensure modularity and maintainability. The API can be deployed using Docker, and we've incorporated user authentication with different roles, such as Athlete and Committee, using the Devise gem.

This project is meant to provide a flexible and robust system for managing Olympic event data, while also showcasing good software engineering practices.

## Clean Architecture Overview

Welcome to the Olympic Games API! This section provides an overview of the project's architecture based on Clean Architecture principles. The architecture promotes separation of concerns, modularity, and maintainability.

### Clean Architecture Layers

Our application follows the Clean Architecture pattern, which consists of several layers that encapsulate different aspects of the system. Each layer has a specific responsibility and interacts with other layers through defined interfaces.

### 1. Presentation Layer (Controllers)

This layer handles the presentation logic and communication with external systems. It receives HTTP requests, processes them, and returns appropriate responses. Controllers are responsible for input validation and data transformation.

**Relationships:**
- Communicates with Use Case Layer (Interactors).

### 2. Use Case Layer (Interactors)

The Use Case layer contains application-specific business rules and logic. It encapsulates use cases, which represent high-level application operations. Use cases interact with entities and gateways to achieve their goals.

**Relationships:**
- Communicates with Domain Layer (Entities).
- Communicates with Data Access Layer (Gateways).
- Communicates with Presentation Layer (Controllers).

**Relationships:**
- Communicates with Use Case Layer (Interactors).

### 4. Data Access Layer (Gateways)

The Data Access layer abstracts interactions with external data sources, such as databases or external services. Gateways provide interfaces for retrieving and storing data without exposing implementation details.

**Relationships:**
- Communicates with Use Case Layer (Interactors).

### 5. Presentation Layer (Presenters)

The Presenter layer is responsible for formatting and transforming data from the Use Case layer into a format suitable for display. It prepares data for rendering in different output formats, such as JSON or HTML.

**Relationships:**
- Communicates with Use Case Layer (Interactors).
- Communicates with Presentation Layer (Controllers).

### 6. Frameworks & Drivers

The outermost layer contains external frameworks, libraries, and tools. It includes components like the web framework (Rails), the database (ActiveRecord), and external APIs. This layer adapts and communicates with the inner layers.

**Relationships:**
- Communicates with Presentation Layer (Controllers).

### Architecture Overview

Here's an overview of how the layers interact within our Olympic Games API:

```mermaid
graph TD;
    PresentationLayer/Controller-->UseCaseLayer/Interactors;
    PresentationLayer/Controller-->PresentationLayer/Presenter;
    PresentationLayer/Presenter-->PresentationLayer/Controller
    UseCaseLayer/Interactors-->DataAccessLayer/Gateways;
    DataAccessLayer/Gateways-->Frameworks&Drivers;
    Frameworks&Drivers;
```

## Endpoints

Welcome to the Olympic Games API! This README provides a comprehensive overview of the available endpoints, along with their expected request bodies, success responses, and error responses.

### Users

#### Signup

- **Endpoint**: `/signup`
- **Http Verb**: `POST`
- **Request Body**:
    ```json
    {
        "user": {
            "email": "athlete@test.com",
            "password": "123456",
            "name": "athlete",
            "role": "athlete" // or "committee"
        }
    }
    ```
- **Success Response**:
    ```json
    {
        "status": { "code": 201, "message": "Signed up successfully." },
        "data": {
            "user": {
            "id": 1,
            "email": "athlete@test.com",
            "name": "athlete"
            }
        }
    }
    ```
- **Error Responses**:
    - Email Field Missing:
        ```json
            {
                "status": { 
                    "code": 422, 
                    "message": "User could not be created successfully." 
                    },
                "data": { 
                    "errors": "Email can't be blank and Email is invalid" 
                }
            }
        ```
    - Password Field Missing:
        ```json
            {
                "status": { 
                    "code": 422, 
                    "message": "User could not be created successfully." 
                },
                "data": { 
                    "errors": "Password can't be blank and Password is too short (minimum is 6 characters)" 
                }
            }
        ```
    - Name Field Missing:
        ```json
            {
                "status": { 
                    "code": 422, 
                    "message": "User could not be created successfully." 
                },
                "data": { 
                    "errors": "Name can't be blank" 
                }
            }
        ```
    - Invalid or Missing Role:
        ```json
            {
                "status": 422,
                "message": "Invalid or missing user role. Only accept <athlete> or <committee>"
            }
        ```
#### Login

- **Endpoint**: `/login`
- **Http Verb**: `POST`
- **Request Body**:
    ```json
    {
        "user": {
            "email": "athlete@test.com",
            "password": "123456"
        }
    }
    ```
- **Success Response**:
    ```json
    {
        "status": { 
            "code": 200, 
            "message": "Logged in successfully." 
        },
        "data": {
            "user": {
                "id": 1,
                "email": "athlete@test.com",
                "name": "athlete"
            }
        }
    }
    ```
- **Error Responses**:
    ```json
        {
            "status": 401,
            "message": "Invalid email or password."
        }
    ```

#### Logout

- **Endpoint**: `/logout`
- **Http Verb**: `DELETE`
- **Headers**: `{ "Authorization": "Bearer <TOKEN>" }`
- **Success Response**:
    ```json
    {
        "status": 200,
        "message": "Logged out successfully."
    }
    ```
- **Error Responses**:
    - Token Expired:
        ```json
        {
            "status": { 
                "code": 403, 
                "message": "The token has expired." 
            }
        }
        ```
    - Token Missing:
         ```json
        {
            "status": { 
                "code": 401, 
                "message": "A token must be passed." 
            }
        }
        ```

### Modalities
- **Endpoint**: `/modalities`

#### Create
**<sub>Only <strong>committee</strong> user can create a modality</sub>

- **Headers**: `{ "Authorization": "Bearer <TOKEN>" }`
- **Http Verb**: `POST`
- **Request Body**:
    ```json
    {
        "name": "Lançamento de Dardo",
        "unit": "meters"
    }
    ```
- **Success Response**:
    ```json
    {
	    "status": {
		    "code": 201,
		    "message": "Modality created successfully."
	    },
	    "data": {
		    "modality": {
                "id": 3,
                "name": "Lançamento de Dardo",
                "unit": "meters"
		    }
	    }
    }
    ```
- **Error Responses**:
    - Name Field Missing:
        ```json
        {
            "status": {
                "code": 422,
                "message": "Modality could not be created successfully."
            },
            "data": {
                "errors": "Name can't be blank"
            }
        }
        ```
    - Unit Field Missing:
         ```json
        {
            "status": 422,
            "message": "invalid unit."
        }
        ```
    - Wrong user type:
         ```json
        {
            "status": {
                "code": 403,
                "message": "You are not authorized to perform this action."
            }
        }
        ```

#### Get all

- **Http Verb**: `GET`
- **Success Response**:
    ```json
    {
        "status": {
            "code": 200,
            "message": "Modalities retrieved successfully."
        },
        "data": {
            "modalities": [
                {
                    "id": 1,
                    "name": "100m rasos",
                    "unit": "seconds"
                },
                {
                    "id": 2,
                    "name": "Lançamento de Dardo",
                    "unit": "meters"
                }
            ]
        }
    }
    ```

#### Show

- **Endpoint**: `/modalities/:id`
- **Http Verb**: `GET`
- **Success Response**:
    ```json
    {
        "status": {
            "code": 200,
            "message": "Modality retrieved successfully."
        },
        "data": {
            "modality": {
                "id": 2,
                "name": "Lançamento de Dardo",
                "unit": "meters"
            }
        }
    }
    ```
- **Error Responses**:
    - Missing Modality:
        ```json
        {
            "status": 404,
            "message": "Modality not found."
        }
        ```