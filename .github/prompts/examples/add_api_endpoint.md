## Goal: Add User Profile API Endpoints

**Context:**
The application currently lacks API endpoints for user profile management. Users need to be able to view and update their profile information through our REST API.

**Requirements:**
1. Create RESTful endpoints for user profile operations
2. Implement proper authentication and authorization
3. Add input validation and sanitization
4. Include rate limiting for security
5. Generate OpenAPI documentation
6. Add comprehensive test coverage

**API Specifications:**

### GET /api/v1/users/{userId}/profile
- **Authentication:** Required (Bearer token)
- **Authorization:** Users can only access their own profile unless admin
- **Response:** User profile object
- **Status Codes:** 200, 401, 403, 404

### PUT /api/v1/users/{userId}/profile
- **Authentication:** Required (Bearer token)
- **Authorization:** Users can only update their own profile unless admin
- **Request Body:** Partial user profile object
- **Validation:** Email format, username uniqueness
- **Response:** Updated user profile object
- **Status Codes:** 200, 400, 401, 403, 404, 422

### POST /api/v1/users/{userId}/avatar
- **Authentication:** Required (Bearer token)
- **Authorization:** Users can only update their own avatar
- **Request:** Multipart form data with image file
- **Validation:** File type (jpg, png), size limit (5MB)
- **Response:** Avatar URL
- **Status Codes:** 201, 400, 401, 403, 413

**Technical Considerations:**
- Use existing authentication middleware
- Implement DTO pattern for request/response
- Add database migrations if needed
- Update API documentation
- Consider caching strategy for profile data

**Success Criteria:**
- [ ] All endpoints implemented and working
- [ ] Authentication and authorization properly enforced
- [ ] Input validation prevents invalid data
- [ ] Rate limiting configured (100 requests per hour)
- [ ] OpenAPI spec updated
- [ ] Test coverage > 90%
- [ ] Response time < 200ms for GET requests
